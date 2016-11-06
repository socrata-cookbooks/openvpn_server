# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: resource_openvpn_server_config
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/resource'
require_relative 'helpers_config'

class Chef
  class Resource
    # A Chef resource for generating OpenVPN configs.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnServerConfig < Resource
      provides :openvpn_server_config

      default_action :create

      #
      # Allow user to override the OpenVPN config file path.
      #
      property :path, String, default: '/etc/openvpn/server.conf'

      #
      # The directory in which OpenVPN's certificates are stored.
      #
      property :key_path, String, default: '/etc/openvpn/keys'

      #
      # Set up a (hopefully relatively sane) default config hash that can
      # overridden in its entirety by the user passing in a new one.
      #
      # OpenVPN's config style uses dashes in multi-word keys. To make method
      # calls and attributes easier, we'll accept them as underscores and
      # translate them when rendering the final file.
      #
      property :config,
               Hash,
               default: lazy { |r|
                 Mash.new(dev: 'tun0',
                          local: r.node['ipaddress'],
                          proto: 'udp',
                          port: 1194,
                          server: '10.8.0.0 255.255.0.0',

                          user: 'nobody',
                          group: 'nogroup',

                          auth: 'SHA512',
                          cipher: 'AES-256-CBC',
                          script_security: 2,

                          keepalive: '10 120',
                          reneg_sec: 604_800,

                          ca: ::File.join(r.key_path, 'ca.crt'),
                          cert: ::File.join(r.key_path, 'server.crt'),
                          key: ::File.join(r.key_path, 'server.key'),
                          dh: ::File.join(r.key_path, 'dh2048.pem'),
                          crl_verify: '/etc/openvpn/crl.pem',
                          up: '/etc/openvpn/server.up.sh',
                          log: '/var/log/openvpn.log',

                          tls_auth: ::File.join(r.key_path, 'static.key'),
                          key_direction: 0,

                          client_config_dir: '/etc/openvpn/clients',
                          ccd_exclusive: true,

                          push: { explicit_exit_notify: true, inactive: 900 })
               },
               coerce: proc { |val| Mash.new(val) }

      #
      # Allow individual properties to be fed in so that they're merged with
      # the default config but don't totally blow it away, e.g.:
      #
      #   openvpn_server_config 'default' do
      #     dev 'tap'
      #     auth 'SHA512'
      #     log '/tmp/openvpn.log'
      #     push inactive: 1_800
      #     push dhcp_option: { dns0: 'DNS 8.8.8.8', dns1: 'DNS 8.8.4.4' }
      #     push dhcp_option: { dns2: false }
      #     push dhcp_option: { search: 'DOMAIN example.com' }
      #   end
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        super
      rescue NoMethodError
        raise if !block.nil? || args.length > 1
        case args.length
        when 1
          merge!(config, method_symbol, args[0])
        when 0
          config[method_symbol]
        end
      end

      #
      # Respond to missing methods.
      #
      # (see Object#respond_to_missing?)
      #
      def respond_to_missing?(method_symbol, *args, &block)
        block.nil? && args.length <= 1 && !method_symbol.match(/^to/) || super
      end

      #
      # Render a config file using the set config hash and path.
      #
      action :create do
        file new_resource.path do
          content OpenvpnServer::Helpers::Config.new(new_resource.config).to_s
        end
      end

      #
      # Delete the config file.
      #
      action :delete do
        file(new_resource.path) { action :delete }
      end

      #
      # Recursively merge a hash argument into a config hash.
      #
      # @param hsh [Hash] a config hash
      # @param key [Hash] the key to deep merge into the config
      # @param val [*] the value to deep merge into the config
      #
      def merge!(hsh, key, val)
        case val
        when Hash
          hsh[key] ||= Mash.new
          val.each do |k, v|
            merge!(hsh[key], k, v)
          end
        else
          hsh[key] = val
        end
      end
    end
  end
end
