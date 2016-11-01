# encoding: utf-8
# frozen_string_literal: true

require_relative '../rhel'

describe 'resources::openvpn_server_app::redhat::7_2' do
  include_context 'resources::openvpn_server_app::rhel'

  let(:platform) { 'redhat' }
  let(:platform_version) { '7.2' }

  it_behaves_like 'any RHEL platform'
end
