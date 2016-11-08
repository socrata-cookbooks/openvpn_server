# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'openvpn_server::default' do
  %i(version config).each { |a| let(a) { nil } }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      unless version.nil?
        node.normal['openvpn_server']['app']['version'] = version
      end
      node.normal['openvpn_server']['config'] = config unless config.nil?
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any attribute set' do
    it 'installs the OpenVPN app' do
      expect(chef_run).to install_openvpn_server_app('default')
        .with(version: version)
    end

    it 'creates the OpenVPN config' do
      expect(chef_run).to create_openvpn_server_config('default')
    end

    it 'enables and starts the OpenVPN service' do
      expect(chef_run).to enable_openvpn_server_service('default')
      expect(chef_run).to start_openvpn_server_service('default')
    end
  end

  context 'all default attributes' do
    it_behaves_like 'any attribute set'

    it 'creates a default OpenVPN config' do
      expected = Mash.new(dev: 'tun0',
                          local: '10.0.0.2',
                          proto: 'udp',
                          port: 1194,
                          server: '10.8.0.0 255.255.0.0',
                          user: 'nobody',
                          group: 'nogroup',
                          auth: 'SHA512',
                          cipher: 'AES-256-CBC',
                          script_security: 2,
                          keepalive: '10 120',
                          reneg_sec: 604_800,
                          ca: '/etc/openvpn/keys/ca.crt',
                          cert: '/etc/openvpn/keys/server.crt',
                          key: '/etc/openvpn/keys/server.key',
                          dh: '/etc/openvpn/keys/dh2048.pem',
                          crl_verify: '/etc/openvpn/crl.pem',
                          up: '/etc/openvpn/server.up.sh',
                          log: '/var/log/openvpn.log',
                          tls_auth: '/etc/openvpn/keys/static.key',
                          key_direction: 0,
                          client_config_dir: '/etc/openvpn/clients',
                          ccd_exclusive: true,
                          push: { explicit_exit_notify: true, inactive: 900 })
      expect(chef_run).to create_openvpn_server_config('default')
        .with(config: expected)
    end
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden config attribute' do
    let(:config) { { user: 'me', group: 'me', example: 'test' } }

    it_behaves_like 'any attribute set'

    it 'creates the expected OpenVPN config' do
      expected = Mash.new(dev: 'tun0',
                          local: '10.0.0.2',
                          proto: 'udp',
                          port: 1194,
                          server: '10.8.0.0 255.255.0.0',
                          user: 'me',
                          group: 'me',
                          auth: 'SHA512',
                          cipher: 'AES-256-CBC',
                          script_security: 2,
                          keepalive: '10 120',
                          reneg_sec: 604_800,
                          ca: '/etc/openvpn/keys/ca.crt',
                          cert: '/etc/openvpn/keys/server.crt',
                          key: '/etc/openvpn/keys/server.key',
                          dh: '/etc/openvpn/keys/dh2048.pem',
                          crl_verify: '/etc/openvpn/crl.pem',
                          up: '/etc/openvpn/server.up.sh',
                          log: '/var/log/openvpn.log',
                          tls_auth: '/etc/openvpn/keys/static.key',
                          key_direction: 0,
                          client_config_dir: '/etc/openvpn/clients',
                          ccd_exclusive: true,
                          push: { explicit_exit_notify: true, inactive: 900 },
                          example: 'test')
      expect(chef_run).to create_openvpn_server_config('default')
        .with(config: expected)
    end
  end
end
