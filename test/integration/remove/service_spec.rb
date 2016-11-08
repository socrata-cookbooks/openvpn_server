# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::default::service' do
  impact 1.0
  title 'OpenVPN is stopped and disabled'
  desc 'OpenVPN is stopped and disabled'

  describe service('openvpn') do
    it 'is not enabled' do
      expect(subject).to_not be_enabled
    end

    it 'is not running' do
      expect(subject).to_not be_running
    end
  end
end
