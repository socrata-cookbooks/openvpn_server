# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: resource_openvpn_server_static_key
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
    # A Chef resource for generating OpenVPN static shared keys.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnServerStaticKey < Resource
      provides :openvpn_server_static_key

      default_action :create

      #
      # The path of the key file.
      #
      property :path, String, name_property: true

      #
      # Render a config file using the set config hash and path.
      #
      action :create do
        execute "Generate the OpenVPN static key - #{new_resource.path}" do
          command "openvpn --genkey --secret #{new_resource.path}"
          creates new_resource.path
          sensitive true
        end
      end

      #
      # Delete the config file.
      #
      action :delete do
        file(new_resource.path) { action :delete }
      end
    end
  end
end
