# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_static_key'

describe 'resources::openvpn_server_static_key::ubuntu::14_04' do
  include_context 'resources::openvpn_server_static_key'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  it_behaves_like 'any platform'
end
