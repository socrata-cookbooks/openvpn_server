# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'openvpn_server::default' do
  let(:version) { nil }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      unless version.nil?
        node.normal['openvpn_server']['app']['version'] = version
      end
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
  end

  context 'an overridden version attribute' do
    let(:version) { '1.2.3' }

    it_behaves_like 'any attribute set'
  end
end
