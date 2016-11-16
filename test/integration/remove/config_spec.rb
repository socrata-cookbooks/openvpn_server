# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::remove::config' do
  impact 1.0
  title 'OpenVPN config is deleted'
  desc 'OpenVPN config is deleted'

  %w(
    /etc/openvpn/keys /etc/openvpn/server.up.d /etc/openvpn/server.down.d
  ).each do |d|
    describe directory(d) do
      it 'does not exist' do
        expect(subject).to not_exist
      end
    end
  end

  %w(
    /etc/openvpn/server.up.sh
    /etc/openvpn/server.down.sh
    /etc/openvpn/server.conf
  ).each do |f|
    describe file(f) do
      it 'does not exist' do
        expect(subject).to_not exist
      end
    end
  end
end
