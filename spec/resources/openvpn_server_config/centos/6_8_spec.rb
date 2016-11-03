# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_config'

describe 'resources::openvpn_server_config::centos::6_8' do
  include_context 'resources::openvpn_server_config'

  let(:platform) { 'centos' }
  let(:platform_version) { '6.8' }

  it_behaves_like 'any platform'
end
