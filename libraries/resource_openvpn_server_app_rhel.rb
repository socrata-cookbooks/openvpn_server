# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: resource_openvpn_server_app_rhel
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

require 'chef/dsl/include_recipe'
require_relative 'resource_openvpn_server_app'

class Chef
  class Resource
    # A Chef resource for managing the OpenVPN server packages on RHEL.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnServerAppRhel < OpenvpnServerApp
      include Chef::DSL::IncludeRecipe

      provides :openvpn_server_app, platform_family: 'rhel'

      #
      # Configure EPEL before trying to install OpenVPN.
      #
      action :install do
        include_recipe 'yum-epel'
        super()
      end

      #
      # Configure EPEL before trying to upgrade OpenVPN.
      #
      action :upgrade do
        include_recipe 'yum-epel'
        super()
      end

      #
      # On RHEL platforms, do a package remove as our remove action.
      #
      action :remove do
        package('openvpn') { action :remove }
      end
    end
  end
end
