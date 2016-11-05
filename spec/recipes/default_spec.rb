# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'openvpn_server::default' do
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the OpenVPN app' do
    expect(chef_run).to install_openvpn_server_app('default')
  end

  it 'creates the OpenVPN config' do
    expect(chef_run).to create_openvpn_server_config('default')
  end

  it 'enables and starts the OpenVPN service' do
    expect(chef_run).to enable_openvpn_server_service('default')
    expect(chef_run).to start_openvpn_server_service('default')
  end
end
