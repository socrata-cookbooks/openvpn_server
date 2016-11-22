# encoding: utf-8
# frozen_string_literal: true

require 'time'
require_relative '../spec_helper'
require_relative '../../libraries/helpers_request'
require_relative '../../libraries/helpers_certificate'

describe OpenvpnServer::Helpers::Certificate do
  {
    request: ::OpenvpnServer::Helpers::Request.new(
      country: 'US',
      state: 'Washington',
      city: 'Seattle',
      organization: 'Example',
      department: 'Engineering',
      common_name: 'user255',
      email: 'user255@example.com',
      key: OpenSSL::PKey::RSA.new(2048)
    ),
    root_ca: OpenSSL::X509::Certificate.new(
      File.read(File.expand_path('../../data/ca.crt', __FILE__))
    ),
    root_key: OpenSSL::PKey::RSA.new(
      File.read(File.expand_path('../../data/ca.key', __FILE__))
    ),
    serial: 255,
    expires: (DateTime.now >> 1200).to_time
  }.each { |k, v| let(k) { v } }

  shared_examples_for 'any type of certificate object' do
    describe '#initialize' do
      it 'returns a new object' do
        expected = OpenvpnServer::Helpers::Certificate
        expect(certificate).to be_an_instance_of(expected)
      end
    end

    describe '#not_before' do
      it 'returns the start time of the cert' do
        expect(certificate.not_before.to_s).to match(/^20[0-9][0-9].*UTC$/)
      end
    end

    describe '#not_after' do
      it 'returns the expire time of the cert' do
        expect(certificate.not_after.to_s).to match(/^21[0-9][0-9].*UTC$/)
      end
    end

    {
      country: 'US',
      state: 'Washington',
      city: 'Seattle',
      organization: 'Example',
      department: 'Engineering',
      common_name: 'user255',
      email: 'user255@example.com'
    }.each do |k, v|
      describe "##{k}" do
        it "returns the cert #{k}" do
          expect(certificate.send(k)).to eq(v)
        end
      end
    end

    describe '#serial' do
      it 'returns a BN helper object' do
        expect(certificate.serial).to be_an_instance_of(
          OpenvpnServer::Helpers::BN
        )
        expect(certificate.serial.to_i).to eq(255)
        expect(certificate.serial.to_s).to eq('FF')
      end
    end

    describe '#bits' do
      it 'returns the number of bits' do
        expect(certificate.bits).to eq(2048)
      end
    end

    describe '#to_s' do
      it 'returns the certificate body ready for a pem file' do
        expect(certificate.to_s).to match(/^-----BEGIN CERTIFICATE-----$/)
        expect(certificate.to_s).to match(/^-----END CERTIFICATE-----$/)
      end
    end

    describe '#certificate' do
      it 'returns an X509 certificate object' do
        expected = OpenSSL::X509::Certificate
        expect(certificate.send(:certificate)).to be_an_instance_of(expected)
      end

      it 'sets the cert start time' do
        not_before = certificate.send(:certificate).not_before
        expect(not_before.to_s).to match(/^20[0-9][0-9].*UTC$/)
      end

      it 'sets the cert version' do
        expect(certificate.send(:certificate).version).to eq(2)
      end

      it 'sets the cert serial' do
        expect(certificate.send(:certificate).serial.to_i).to eq(255)
      end

      it 'signs the certificate' do
        sa = certificate.send(:certificate).signature_algorithm
        expect(sa).to eq('sha256WithRSAEncryption')
      end
    end

    describe '#configure!' do
      it 'sets the cert expire time' do
        not_after = certificate.send(:certificate).not_after
        expect(not_after.to_s).to match(/^21[0-9][0-9].*UTC$/)
      end

      it 'sets the cert subject' do
        subject = certificate.send(:certificate).subject
        expect(subject).to be_an_instance_of(OpenSSL::X509::Name)
        expected = '/C=US/ST=Washington/L=Seattle/O=Example/OU=Engineering/' \
                   'CN=user255/emailAddress=user255@example.com'
        expect(subject.to_s).to eq(expected)
      end

      it 'sets the cert issuer' do
        issuer = certificate.send(:certificate).issuer
        expect(issuer).to be_an_instance_of(OpenSSL::X509::Name)
        expect(issuer.to_s).to eq(
          '/C=US/ST=Washington/L=Seattle/O=OpenVPN/OU=Testing/CN=example'
        )
      end

      it 'sets the cert public key' do
        public_key = certificate.send(:certificate).public_key
        expect(public_key).to be_an_instance_of(OpenSSL::PKey::RSA)
      end

      it 'sets the cert serial' do
        expect(certificate.send(:certificate).serial.to_i).to eq(255)
      end

      it 'adds the cert extensions' do
        expect(certificate.send(:certificate).extensions.length).to eq(6)
      end
    end

    describe '#add_extensions!' do
      it 'adds six extensions' do
        expect(certificate.send(:certificate).extensions.length).to eq(6)
      end

      [
        'basicConstraints = CA:FALSE',
        'nsComment = Chef Generated Certificate',
        'authorityKeyIdentifier = keyid:E7:C0:BF:56:E1:43:97:8E:6B:16:D4:9C:' \
          'CC:9E:8B:08:F9:5D:90:17, DirName:/C=US/ST=Washington/L=Seattle/' \
          'O=OpenVPN/OU=Testing/CN=example, serial:21:76:8E:E1:01:D8:8E:C5:' \
          'A1:05:FE:BB:B9:BB:21:ED:90:FC:FC:45, ',
        'extendedKeyUsage = TLS Web Client Authentication',
        'keyUsage = Digital Signature'
      ].each do |str|
        it "adds the #{str.split[0]} extension" do
          extensions = certificate.send(:certificate).extensions
          expect(extensions.map(&:to_s)).to include(str)
        end
      end

      it 'adds the subjectKeyIdentifier extension' do
        extensions = certificate.send(:certificate).extensions
        expect(extensions.map { |e| e.to_s.split.first })
          .to include('subjectKeyIdentifier')
      end
    end

    describe '#extension_map' do
      it 'returns a mapping of common extensions' do
        expected = {
          'basicConstraints' => 'CA:FALSE',
          'nsComment' => 'Chef Generated Certificate',
          'subjectKeyIdentifier' => 'hash',
          'authorityKeyIdentifier' => 'keyid:always,issuer:always',
          'extendedKeyUsage' => 'clientAuth',
          'keyUsage' => 'digitalSignature'
        }
        expect(certificate.send(:extension_map)).to eq(expected)
      end
    end
  end

  context 'a certificate initialized from a config hash' do
    let(:certificate) do
      described_class.new(request: request,
                          root_ca: root_ca,
                          root_key: root_key,
                          serial: serial,
                          expires: expires)
    end

    it_behaves_like 'any type of certificate object'
  end

  context 'a certificate initialized from a string' do
    let(:certificate) do
      described_class.new(File.read(File.expand_path('../../data/FF.pem',
                                                     __FILE__)))
    end

    it_behaves_like 'any type of certificate object'
  end

  context 'a certificate initialized from a file' do
    let(:certificate) do
      described_class.from_file(File.expand_path('../../data/FF.pem',
                                                 __FILE__))
    end

    it_behaves_like 'any type of certificate object'
  end
end
