# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/helpers_config'

describe OpenvpnServer::Helpers::Config do
  let(:param) { nil }
  let(:config) { described_class.new(param) }

  describe 'UP_SCRIPT' do
    it 'is set to the expected string' do
      expected = <<-EOH.gsub(/^ {8}/, '')
        #!/bin/sh
        #
        # OpenVPN startup script.
        # This file is generated by Chef. Changes to it will be overwritten.

        # Turn on IP forwarding.
        /sbin/sysctl -w net.ipv4.ip_forward=1

        # Run any script under /etc/openvpn/server.up.d.
        FILES=$(/bin/ls /etc/openvpn/server.up.d/*.sh 2>/dev/null || true)
        for f in $FILES; do
          . $f
        done
      EOH
      expect(described_class::UP_SCRIPT).to eq(expected)
    end
  end

  describe 'DOWN_SCRIPT' do
    it 'is set to the expected string' do
      expected = <<-EOH.gsub(/^ {8}/, '')
        #!/bin/sh
        #
        # OpenVPN shutdown script.
        # This file is generated by Chef. Changes to it will be overwritten.

        # Run any script under /etc/openvpn/server.down.d.
        FILES=$(/bin/ls /etc/openvpn/server.down.d/*.sh 2>/dev/null || true)
        for f in $FILES; do
          . $f
        done
      EOH
      expect(described_class::DOWN_SCRIPT).to eq(expected)
    end
  end

  describe '#initialize' do
    context 'a populated param' do
      let(:param) { { auth: 'SHA512', user: 'nobody' } }

      it 'saves the provided config hash' do
        expect(config.instance_variable_get(:@config)).to eq(param)
      end
    end

    context 'a nil param' do
      let(:param) { nil }

      it 'saves an empty config hash' do
        expect(config.instance_variable_get(:@config)).to eq({})
      end
    end
  end

  describe '#to_s' do
    context 'a populated param' do
      let(:param) do
        {
          dev: 'tun0',
          proto: 'udp',
          port: 1194,
          local: '10.10.10.1',
          server: '10.10.11.0 255.255.255.0',
          topology: 'subnet',
          user: 'nobody',
          group: 'nogroup',
          auth: 'SHA512',
          cipher: 'AES-256-CBC',
          tls_cipher: %w(
            TLS-DHE-RSA-WITH-AES-256-GCM-SHA384
            TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
          ),
          key_direction: 0,
          comp_lzo: 'yes',
          keepalive: '10 120',
          ccd_exclusive: true,
          script_security: 2,
          cert: '/etc/openvpn/keys/server.crt',
          key: '/etc/openvpn/keys/server.key',
          dh: '/etc/openvpn/keys/dh2048.pem',
          ca: '/etc/openvpn/keys/ca.crt',
          client_config_dir: '/etc/openvpn/clients',
          crl_verify: '/etc/openvpn/crl.pem',
          log: '/var/log/openvpn.log',
          tls_auth: '/etc/openvpn/keys/static.key',
          tmp_dir: '/etc/openvpn/tmp',
          up: '/etc/openvpn/server.up.sh',
          plugin: {
            plug1: '/path/to/plug1',
            plug2: false,
            plug3: '/path/to/plug3'
          },
          reneg_sec: 604_800,
          push: {
            redirect_gateway: 'def1 bypass-dhcp autolocal',
            inactive: 900,
            comp_lzo: 'yes',
            explicit_exit_notify: true,
            dhcp_option: {
              local_dns: 'DNS 8.8.8.8',
              backup_dns: 'DNS 8.8.4.4',
              backup_backup: false,
              search_path: 'DOMAIN example.com'
            }
          }
        }
      end

      it 'returns the expected config string' do
        expected = <<-EOH.gsub(/^ +/, '')
          # OpenVPN server configuration file.
          # This file is generated by Chef. Changes to it will be overwritten.
          auth SHA512
          ca /etc/openvpn/keys/ca.crt
          ccd-exclusive
          cert /etc/openvpn/keys/server.crt
          cipher AES-256-CBC
          client-config-dir /etc/openvpn/clients
          comp-lzo yes
          crl-verify /etc/openvpn/crl.pem
          dev tun0
          dh /etc/openvpn/keys/dh2048.pem
          group nogroup
          keepalive 10 120
          key /etc/openvpn/keys/server.key
          key-direction 0
          local 10.10.10.1
          log /var/log/openvpn.log
          plugin /path/to/plug1
          plugin /path/to/plug3
          port 1194
          proto udp
          reneg-sec 604800
          script-security 2
          server 10.10.11.0 255.255.255.0
          tls-auth /etc/openvpn/keys/static.key
          tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256
          tmp-dir /etc/openvpn/tmp
          topology subnet
          up /etc/openvpn/server.up.sh
          user nobody
          push "comp-lzo yes"
          push "dhcp-option DNS 8.8.4.4"
          push "dhcp-option DNS 8.8.8.8"
          push "dhcp-option DOMAIN example.com"
          push "explicit-exit-notify"
          push "inactive 900"
          push "redirect-gateway def1 bypass-dhcp autolocal"
        EOH
        expect(config.to_s).to eq(expected)
      end
    end

    context 'a nil param' do
      let(:param) { nil }

      it 'returns an empty config string' do
        expected = <<-EOH.gsub(/^ +/, '')
          # OpenVPN server configuration file.
          # This file is generated by Chef. Changes to it will be overwritten.
        EOH
        expect(config.to_s).to eq(expected)
      end
    end
  end

  describe '#config' do
    context 'a populated param' do
      let(:param) { { auth: 'SHA512', user: 'nobody' } }

      it 'returns the expected config hash' do
        expect(config.send(:config)).to eq(param)
      end
    end

    context 'a nil param' do
      let(:param) { nil }

      it 'returns the expected config hash' do
        expect(config.send(:config)).to eq({})
      end
    end
  end

  describe '#base_config_segment' do
    let(:segment) { config.send(:base_config_segment) }

    context 'some settings' do
      let(:param) { { auth: 'SHA512', user: 'nobody' } }

      it 'returns the expected segment string' do
        expected = <<-EOH.gsub(/^ +/, '').strip
          # OpenVPN server configuration file.
          # This file is generated by Chef. Changes to it will be overwritten.
          auth SHA512
          user nobody
        EOH
        expect(segment).to eq(expected)
      end
    end

    context 'no settings' do
      let(:param) { nil }

      it 'returns just the header string' do
        expected = <<-EOH.gsub(/^ +/, '').strip
          # OpenVPN server configuration file.
          # This file is generated by Chef. Changes to it will be overwritten.
        EOH
        expect(segment).to eq(expected)
      end
    end
  end

  describe '#push_config_segment' do
    let(:push) { nil }
    let(:param) { { thing1: 'thing1', thing2: 'thing2', push: push } }
    let(:segment) { config.send(:push_config_segment) }

    context 'some push settings' do
      let(:push) do
        {
          redirect_gateway: 'def1 bypass-dhcp autolocal',
          inactive: 900,
          comp_lzo: 'yes',
          dhcp_option: {
            local_dns: 'DNS 8.8.8.8',
            backup_dns: 'DNS 8.8.4.4'
          }
        }
      end

      it 'returns the expected segment string' do
        expected = <<-EOH.gsub(/^ +/, '').strip
          push "comp-lzo yes"
          push "dhcp-option DNS 8.8.4.4"
          push "dhcp-option DNS 8.8.8.8"
          push "inactive 900"
          push "redirect-gateway def1 bypass-dhcp autolocal"
        EOH
        expect(segment).to eq(expected)
      end
    end

    context 'no push settings' do
      let(:push) { nil }

      it 'returns nil' do
        expect(segment).to eq(nil)
      end
    end
  end

  describe '#config_segment_for_hash' do
    let(:key) { :thing }
    let(:val) { nil }
    let(:segment) { config.send(:config_segment_for_hash, key, val) }

    context 'a populated hash' do
      let(:val) { { key1: 'val1', key2: 'val2', key3: 'val3' } }

      it 'returns the expected segment string' do
        expect(segment).to eq("thing val1\nthing val2\nthing val3")
      end
    end

    context 'an empty hash' do
      let(:val) { {} }

      it 'returns an empty string' do
        expect(segment).to eq('')
      end
    end
  end

  describe '#config_segment_for' do
    let(:key) { nil }
    let(:val) { nil }
    let(:segment) { config.send(:config_segment_for, key, val) }

    context 'a simple key' do
      let(:key) { :thing }

      context 'a false value' do
        let(:val) { false }

        it 'returns nil' do
          expect(segment).to eq(nil)
        end
      end

      context 'a nil value' do
        let(:val) { nil }

        it 'returns nil' do
          expect(segment).to eq(nil)
        end
      end

      context 'a true value' do
        let(:val) { true }

        it 'returns the expected segment string' do
          expect(segment).to eq('thing')
        end
      end

      context 'an integer value' do
        let(:val) { 42 }

        it 'returns the expected segment string' do
          expect(segment).to eq('thing 42')
        end
      end

      context 'a string value' do
        let(:val) { 'stuff' }

        it 'returns the expected segment string' do
          expect(segment).to eq('thing stuff')
        end
      end

      context 'an array value' do
        let(:val) { %w(val1 val2) }

        it 'returns the expected segment string' do
          expect(segment).to eq('thing val1:val2')
        end
      end

      context 'a hash value' do
        let(:val) { { hi: 'there', bye: 'here' } }

        it 'returns the expected segment string' do
          expect(segment).to eq("thing here\nthing there")
        end
      end
    end

    context 'a multi-word key' do
      let(:key) { :some_thing_great }

      context 'a string value' do
        let(:val) { 'test' }

        it 'converts the underscores in the key to dashes' do
          expect(segment).to eq('some-thing-great test')
        end
      end
    end
  end
end
