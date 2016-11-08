# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::default::service' do
  impact 1.0
  title 'OpenVPN is enabled and running'
  desc 'OpenVPN is enabled and running'

  describe service('openvpn') do
    it 'is enabled' do
      expect(subject).to be_enabled
    end

    it 'is running' do
      expect(subject).to be_running
    end
  end
end
