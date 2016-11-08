# encoding: utf-8
# frozen_string_literal: true

apt_update 'periodic' if node['platform_family'] == 'debian'

include_recipe 'openvpn_server'
