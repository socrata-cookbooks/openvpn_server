# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_static_key'

describe 'resources::openvpn_server_static_key::redhat::6_6' do
  include_context 'resources::openvpn_server_static_key'

  let(:platform) { 'redhat' }
  let(:platform_version) { '6.6' }

  it_behaves_like 'any platform'
end
