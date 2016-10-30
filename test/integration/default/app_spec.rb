# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::default::app' do
  impact 1.0
  title 'OpenVPN is installed'
  desc 'OpenVPN is installed'

  describe package('openvpn') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
