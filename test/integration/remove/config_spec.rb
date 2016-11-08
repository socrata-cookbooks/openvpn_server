# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::remove::config' do
  impact 1.0
  title 'OpenVPN config is deleted'
  desc 'OpenVPN config is deleted'

  describe file('/etc/openvpn/server.conf') do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end
end
