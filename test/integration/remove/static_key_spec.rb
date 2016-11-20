# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::remove::static_key' do
  impact 1.0
  title 'OpenVPN static key is deleted'
  desc 'OpenVPN static key is deleted'

  describe file('/etc/openvpn/keys/static.key') do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end
end
