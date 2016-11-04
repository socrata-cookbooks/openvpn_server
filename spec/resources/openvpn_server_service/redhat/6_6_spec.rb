# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_service'

describe 'resources::openvpn_server_service::redhat::6_6' do
  include_context 'resources::openvpn_server_service'

  let(:platform) { 'redhat' }
  let(:platform_version) { '6.6' }

  it_behaves_like 'any platform'
end
