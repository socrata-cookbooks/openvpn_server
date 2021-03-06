# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: helpers_config
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

class OpenvpnServer
  class Helpers
    # A helper class for rendering the contents of OpenVPN server config files
    # from config hashes.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Config
      UP_SCRIPT ||= <<-EOH.gsub(/^ {8}/, '').freeze
        #!/bin/sh
        #
        # OpenVPN startup script.
        # This file is generated by Chef. Changes to it will be overwritten.

        # Turn on IP forwarding.
        /sbin/sysctl -w net.ipv4.ip_forward=1

        # Run any script under /etc/openvpn/server.up.d.
        FILES=$(/bin/ls /etc/openvpn/server.up.d/*.sh 2>/dev/null || true)
        for f in $FILES; do
          . $f
        done
      EOH

      DOWN_SCRIPT ||= <<-EOH.gsub(/^ {8}/, '').freeze
        #!/bin/sh
        #
        # OpenVPN shutdown script.
        # This file is generated by Chef. Changes to it will be overwritten.

        # Run any script under /etc/openvpn/server.down.d.
        FILES=$(/bin/ls /etc/openvpn/server.down.d/*.sh 2>/dev/null || true)
        for f in $FILES; do
          . $f
        done
      EOH

      #
      # Initialize a new config object based on a config hash.
      #
      # @param config [Hash] a hash of openvpn keys => values
      #
      # @return [OpenvpnServer::Helpers::Config] the new config object
      #
      def initialize(config = {})
        @config = config || {}
      end

      #
      # Convert the config object to a string suitable for rendering to an
      # OpenVPN server.conf file.
      #
      # @return [String] the config stringified
      #
      def to_s
        [base_config_segment, push_config_segment].compact.join("\n") + "\n"
      end

      private

      attr_reader :config

      #
      # Return the lines of the config representing everything except the
      # push commands (these are extra special cases). This method needs to
      # account for:
      #
      #   * Integer values: { port: 1194 } ==> 'port 1194'
      #   * String values: { auth: 'SHA512' } ==> 'auth SHA512'
      #   * Multi-word keys: { comp_lzo: 'yes' } ==> 'comp-lzo yes'
      #   * Boolean values: { ccd_exclusive: true } ==> 'ccd-exclusive'
      #   * Array values:
      #     { tls_cipher: %w(RSA1 RSA2) } ==> 'tls-cipher RSA1:RSA2'
      #   * Hash values (for easier overrides):
      #     { plugin: { p1: '/path/to/p1', p2: '/path/to/p2' } } ==>
      #     """
      #     plugin /path/to/p1
      #     plugin /path/to/p2
      #     """
      #
      # @return [String] the non-push parts of an OpenVPN config
      #
      def base_config_segment
        segments = [
          <<-EOH.gsub(/^ +/, '').strip
            # OpenVPN server configuration file.
            # This file is generated by Chef. Changes to it will be overwritten.
          EOH
        ]
        config.sort.to_h.each do |k, v|
          next if k.to_s == 'push' || !v
          segments << config_segment_for(k, v)
        end
        segments.compact.join("\n")
      end

      #
      # The push statements in an OpenVPN config are unique in that they're
      # quoted.
      #
      #   * Single push statements:
      #     { push: { comp_lzo: 'yes' } } => 'push "comp-lzo yes"'
      #   * Multiple push statements:
      #     {
      #       push: {
      #         dhcp_option: {
      #           dns0: 'DNS 1.2.3.4',
      #           dns1: 'DNS 1.2.3.5',
      #           dns2: false,
      #           search: 'DOMAIN example.com'
      #         }
      #       }
      #     } ==>
      #     """
      #     push "dhcp-option DNS 1.2.3.4"
      #     push "dhcp-option DNS 1.2.3.5"
      #     push "dhcp-option DOMAIN example.com"
      #     """
      #
      # @return [String, NilClass] the push commands section of an OVPN config
      #
      def push_config_segment
        return unless config[:push]

        tmp = config[:push].sort.to_h.map do |k, v|
          config_segment_for(k, v)
        end.compact.join("\n")
        tmp.lines.map { |l| "push \"#{l.strip}\"" }.join("\n")
      end

      #
      # Generate a config segment for a given key and value when the value is
      # a hash. A hash value indicates an OpenVPN config key that can be
      # declared more than once so results in a multi-line segment.
      #
      # @param key [Symbol] a config key
      # @param val [Hash] a config values hash
      #
      # @return [String] that config segment rendered as a string
      #
      def config_segment_for_hash(key, hsh)
        hsh.sort.to_h.map { |_, val| config_segment_for(key, val) }.compact
           .join("\n")
      end

      #
      # Generate a config segment for a given config key and value.
      #
      # @param key [Symbol] a config key
      # @param val [FalseClass,
      #             NilClass,
      #             TrueClass,
      #             Integer,
      #             String,
      #             Array,
      #             Hash] a config value or set of values
      #
      # @return [String] that config segment rendered as a string
      #
      def config_segment_for(key, val)
        key = key.to_s.tr('_', '-')

        case val
        when FalseClass, NilClass then nil
        when TrueClass then key
        when Integer, String then "#{key} #{val}"
        when Array then "#{key} #{val.join(':')}"
        when Hash then config_segment_for_hash(key, val)
        end
      end
    end
  end
end
