# encoding: utf-8
# frozen_string_literal: true

require_relative '../openvpn_server_app'

shared_context 'resources::openvpn_server_app::debian' do
  include_context 'resources::openvpn_server_app'

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'

    context 'the :remove action' do
      include_context description

      it 'purges the openvpn package' do
        expect(chef_run).to purge_package('openvpn')
      end
    end
  end
end
