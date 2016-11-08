# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

EXPECTED_CONTENT = Regexp.new(<<-EOH.gsub(/^ +/, '')).freeze
  # OpenVPN server configuration file.
  # This file is generated by Chef. Changes to it will be overwritten.
  auth SHA512
  ca /etc/openvpn/keys/ca.crt
  ccd-exclusive
  cert /etc/openvpn/keys/server.crt
  cipher AES-256-CBC
  client-config-dir /etc/openvpn/clients
  crl-verify /etc/openvpn/crl.pem
  dev tun0
  dh /etc/openvpn/keys/dh2048.pem
  group nogroup
  keepalive 10 120
  key /etc/openvpn/keys/server.key
  key-direction 0
  local [0-9]+\.[0-9]+\.[0-9]+\.[0-9]
  log /var/log/openvpn.log
  port 1194
  proto udp
  reneg-sec 604800
  script_security 2
  server 10.8.0.0 255.255.0.0
  tls-auth /etc/openvpn/keys/static.key
  up /etc/openvpn/server.up.sh
  user nobody
  push "explicit-exit-notify"
  push "inactive 900"
EOH

control 'openvpn_server::default::config' do
  impact 1.0
  title 'OpenVPN is configured'
  desc 'OpenVPN is configured'

  describe file('/etc/openvpn/server.conf') do
    it 'has the expected content' do
      expect(subject.content).to match(EXPECTED_CONTENT)
    end
  end
end