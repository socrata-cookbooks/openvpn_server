# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_config'

describe 'resources::openvpn_server_config::ubuntu::14_04' do
  include_context 'resources::openvpn_server_config'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  it_behaves_like 'any platform'
end
