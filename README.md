Openvpn_server Cookbook
=======================
[![Cookbook Version](https://img.shields.io/cookbook/v/openvpn_server.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/openvpn_server.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/openvpn_server.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/openvpn_server.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/openvpn_server
[travis]: https://travis-ci.org/socrata-cookbooks/openvpn_server
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/openvpn_server
[coveralls]: https://coveralls.io/r/socrata-cookbooks/openvpn_server

A Chef cookbook for managing an OpenVPN server.

Requirements
============

This cookbook currently requires Chef 12.5+, or Chef 12.x and the
[compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)
cookbook.

Usage
=====

TODO: Describe how to use the cookbook.

Recipes
=======

***default***

TODO: Describe each component recipe.

Attributes
==========

***default***

TODO: Describe any noteworthy attributes.

Resources
=========

***openvpn_server_app***

Manages the OpenVPN packages.

Syntax:

    openvpn_server_app 'default' do
      version '1.2.3'
      action :install
    end

Actions:

| Action     | Description                        |
|------------|------------------------------------|
| `:install` | Install the OVPN package           |
| `:upgrade` | Upgrade to the latest OVPN package |
| `:remove`  | Purge/remove the OVPN package      |

Properties:

| Property | Default    | Description                                       |
|----------|------------|---------------------------------------------------|
| version  | `nil`      | Install a specific version of the OpenVPN package |
| action   | `:install` | Action(s) to perform                              |

***openvpn_server_config***

Manages the OpenVPN config files.

Syntax:

    openvpn_server_config 'default' do
      path '/etc/openvpn/server.conf'
      key_path '/etc/openvpn/keys'
      config(proto: 'udp', port: 1194)
      auth 'SHA512'
      ccd_exclusive true
      push(explicit_exit_notify: true)
      push(inactive: 1800)
      action :create
    end

Actions:

| Action    | Description                  |
|-----------|------------------------------|
| `:create` | Create the OVPN config files |
| `:delete` | Delete the OVPN config files |

Properties:

| Property | Default                    | Description                         |
|----------|----------------------------|-------------------------------------|
| path     | `/etc/openvpn/server.conf` | Path of the main config file        |
| key_path | `/etc/openvpn/keys`        | Path of the keys directory          |
| config   | See note below             | A hash representing the OVPN config |
| \*       | `nil`                      | Override any specific OVPN setting  |

\* By default, this resource uses a large (hopefully reasonable) configuration
hash. Individual settings can be overridden by passing them as properties to
the resource. The entirety of the config can be overridden by passing a
replacement config property to the resource.

All overrides should be passed to the config resource with underscores where
there would normally be dashes in an OpenVPN config file, e.g.
`client_config_dir` instead of `client-config-dir`.

Any property that is an enabled/disabled switch rather than a string or integer
value can be set by setting a boolean property, e.g. `ccd_exclusive true` would
translate to `ccd-exclusive` in the generated config file.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <jonathan.hartman@socrata.com>

Copyright 2016, Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
