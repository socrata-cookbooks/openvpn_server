# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_server
# Library:: helpers_base
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

module OpenvpnServer
  module Helpers
    # A base helper class for configurating that others can inherit from.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class Base
      class << self
        #
        # Accept one or more properties that are required for a complete
        # configuration of this class. Make each accessible as a method.
        #
        # @param params [nil] just return the current list
        # @param params [Symbol] a single required config item
        # @param params [Array<Symbol>] a list of required config items
        #
        # @return [Array<Symbol>] the current class list of required items
        #
        def required(*params)
          @required ||= []
          Array(params).flatten.each do |p|
            @required << p
            attr_reader p
          end
          @required
        end

        #
        # Store a default value for a property.
        #
        # @param key [Symbol] the property name
        # @param val [Class] the default value of that property
        #
        # @return [Hash] a mapping of default properties to values
        #
        def default(*params)
          @default ||= {}
          unless params.nil? || params.length != 2
            @default[params[0]] = params[1]
            attr_reader params[0]
          end
          @default
        end
      end

      #
      # Initialize a new object based on a hash or another object.
      #
      # @param config [Hash] a hash containing the required config properties
      # @param config [Class] an object containing the required config methods
      #
      # @raise [Chef::Exceptions::ValidationFailed] if the config is incomplete
      #
      def initialize(config)
        process_requireds!(config)
        process_defaults!(config)
      end

      private

      #
      # Process all required config items and raise an exception if they're
      # missing.
      #
      # @param config [Hash] a hash containing the required config properties
      # @param config [Class] an object containing the required config methods
      #
      # @raise [Chef::Exceptions::ValidationFailed] if the config is incomplete
      #
      def process_requireds!(config)
        self.class.required.each do |p|
          val = config.is_a?(Hash) ? config.fetch(p) : config.send(p)
          raise("Required config item missing: #{p}") if val.nil?
          instance_variable_set(:"@#{p}", val)
        end
      end

      #
      # Process all default config items and fill in any missing with default
      # values.
      #
      # @param config [Hash] a hash containing the required config properties
      # @param config [Class] an object containing the required config methods
      #
      def process_defaults!(config)
        self.class.default.each do |k, v|
          val = config.is_a?(Hash) ? config[k] : config.send(k)
          instance_variable_set(:"@#{k}", val || v)
        end
      end
    end
  end
end
