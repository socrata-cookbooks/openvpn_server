# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: helpers_bn
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

require 'openssl'

module OpenvpnServer
  module Helpers
    # A wrapper class for OpenSSL::BN that gives it some methods to be more
    # helpful in an OpenVPN context.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class BN < OpenSSL::BN
      #
      # Instead of returning a string of the serial integer, return it in the
      # format the CA/OpenVPN use:
      #
      #   * Convert to a hex string
      #   * Upcase the string
      #   * Pad the string with zeroes to a multiple of two characters
      #
      # @return [String] the serial number as a string
      #
      def to_s
        s = to_i.to_s(16).upcase
        s.rjust((s.length + 1) / 2 * 2, '0')
      end
    end
  end
end
