# encoding: utf-8
# frozen_string_literal: true

name 'openvpn_server'
maintainer 'Jonathan Hartman'
maintainer_email 'jonathan.hartman@socrata.com'
license 'apachev2'
description 'Installs/Configures openvpn_server'
long_description 'Installs/Configures openvpn_server'
version '0.0.1'
chef_version '>= 12.1'

source_url 'https://github.com/socrata-cookbooks/openvpn_server'
issues_url 'https://github.com/socrata-cookbooks/openvpn_server/issues'

depends 'yum-epel', '~> 1.0'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'scientific'
