# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: resource_openvpn_server_service
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

require 'chef/resource/service'
require 'chef/resource'

class Chef
  class Resource
    # A Chef resource for managing the OpenVPN service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnServerService < Resource
      provides :openvpn_server_service

      default_action %i(enable start)

      #
      # Iterate over each service action and pass it on to a normal service
      # resource.
      #
      Chef::Resource::Service.allowed_actions.each do |a|
        action a do
          service('openvpn') { action a }
        end
      end
    end
  end
end
