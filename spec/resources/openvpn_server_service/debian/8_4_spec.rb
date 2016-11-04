# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_service'

describe 'resources::openvpn_server_service::debian::8_4' do
  include_context 'resources::openvpn_server_service'

  let(:platform) { 'debian' }
  let(:platform_version) { '8.4' }

  it_behaves_like 'any platform'
end
