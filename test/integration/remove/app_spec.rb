# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::remove::app' do
  impact 1.0
  title 'OpenVPN is not installed'
  desc 'OpenVPN is not installed'

  describe package('openvpn') do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end
end
