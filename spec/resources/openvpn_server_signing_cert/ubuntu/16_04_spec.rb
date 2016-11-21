# encoding: utf-8
# frozen_string_literal: true

require_relative '../../openvpn_server_signing_cert'

describe 'resources::openvpn_server_signing_cert::ubuntu::16_04' do
  include_context 'resources::openvpn_server_signing_cert'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '16.04' }

  it_behaves_like 'any platform'
end
