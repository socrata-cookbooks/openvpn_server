# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_signing_cert'

describe 'resources::openvpn_server_signing_cert::centos::7_2_1511' do
  include_context 'resources::openvpn_server_signing_cert'

  let(:platform) { 'centos' }
  let(:platform_version) { '7.2.1511' }

  it_behaves_like 'any platform'
end
