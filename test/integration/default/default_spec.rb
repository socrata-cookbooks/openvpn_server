# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_server::default::default' do
  impact 1.0
  title 'It did some things'
  desc 'It did some things'

  describe file('/dev/null') do
    it 'did some things' do
      pending
      expect(true).to eq(false)
    end
  end
end
