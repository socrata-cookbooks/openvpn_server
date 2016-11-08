# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Recipe:: default
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

attrs = node['openvpn_server']

openvpn_server_app 'default' do
  version attrs['app']['version'] unless attrs['app']['version'].nil?
end
openvpn_server_config 'default' do
  attrs['config'].each do |k, v|
    send(k, v)
  end
end
openvpn_server_service 'default'
