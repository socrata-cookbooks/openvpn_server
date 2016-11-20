# encoding: utf-8
# frozen_string_literal: true

require 'openssl'
require_relative 'spec_helper'

control 'openvpn_server::default::static_key' do
  impact 1.0
  title 'OpenVPN has a valid static key'
  desc 'OpenVPN has a valid static key'

  describe file('/etc/openvpn/keys/static.key') do
    it 'is a valid key' do
      expect(subject.content)
        .to match(/^-----BEGIN OpenVPN Static key V1-----$/)
    end
  end
end
