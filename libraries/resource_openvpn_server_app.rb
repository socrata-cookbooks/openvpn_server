# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: resource_openvpn_server_app
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

class Chef
  class Resource
    # A Chef resource for managing the OpenVPN server packages.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnServerApp < Resource
      default_action :install

      #
      # Let the user opt to install a specific version.
      #
      property :version, String

      #
      # Install the OpenVPN package.
      #
      action :install do
        package 'openvpn' do
          version new_resource.version unless new_resource.version.nil?
        end
      end

      #
      # Upgrade the OpenVPN package.
      #
      action :upgrade do
        package('openvpn') { action :upgrade }
      end

      # The removal action may be a :purge or a :remove depending on the
      # platform, so varies by child resource.
    end
  end
end
