# encoding: utf-8
# frozen_string_literal: true

include_recipe cookbook_name.to_s

openvpn_server_service('remove') { action %i(stop disable) }
openvpn_server_config('remove') { action :delete }
openvpn_server_app('remove') { action :remove }
