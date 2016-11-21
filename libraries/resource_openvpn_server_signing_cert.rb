# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: resource_openvpn_server_signing_cert
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
    # A Chef resource for generating OpenVPN signing certs.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnServerSigningCert < Resource
      provides :openvpn_server_signing_cert

      default_action :create

      #
      # The path of the cert file.
      #
      property :path, String, name_property: true

      #
      # The certificate body. If none is provided, we'll generate a self-signed
      # one.
      #
      property :body,
               String,
               sensitive: true,
               required: true

      #
      # Generate the cert file.
      #
      action :create do
        file(new_resource.path) { content new_resource.body }
      end

      #
      # Delete the cert file.
      #
      action :delete do
        file(new_resource.path) { action :delete }
      end
    end
  end
end
