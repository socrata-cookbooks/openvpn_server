# encoding: utf-8
# frozen_string_literal: true

require_relative '../openvpn_server_app'

shared_context 'resources::openvpn_server_app::rhel' do
  include_context 'resources::openvpn_server_app'

  shared_examples_for 'any RHEL platform' do
    it_behaves_like 'any platform'

    context 'the default action (:install)' do
      include_context description

      it 'configures EPEL' do
        expect(chef_run).to include_recipe('yum-epel')
      end
    end

    context 'the :upgrade action' do
      include_context description

      it 'configures EPEL' do
        expect(chef_run).to include_recipe('yum-epel')
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the openvpn package' do
        expect(chef_run).to remove_package('openvpn')
      end
    end
  end
end
