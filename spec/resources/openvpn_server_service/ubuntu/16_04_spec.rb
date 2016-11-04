# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_service'

describe 'resources::openvpn_server_service::ubuntu::16_04' do
  include_context 'resources::openvpn_server_service'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '16.04' }

  it_behaves_like 'any platform'
end
