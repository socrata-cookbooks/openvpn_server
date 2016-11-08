# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::openvpn_server_app' do
  include_context 'resources'

  let(:resource) { 'openvpn_server_app' }
  %i(version).each { |p| let(p) { nil } }
  let(:properties) { { version: version } }
  let(:name) { 'default' }

  shared_context 'the default action (:install)' do
  end

  shared_context 'the :upgrade action' do
    let(:action) { :upgrade }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden version property' do
    let(:version) { '1.2.3' }
  end

  shared_examples_for 'any platform' do
    context 'the default action (:install)' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates an openvpn_server_app resource' do
          expect(chef_run).to install_openvpn_server_app(name)
        end

        it 'installs the openvpn package' do
          expect(chef_run).to install_package('openvpn').with(version: version)
        end
      end

      context 'all default properties' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden version property' do
        include_context description

        it_behaves_like 'any property set'
      end
    end

    context 'the :upgrade action' do
      include_context description

      it 'creates an openvpn_server_app resource' do
        expect(chef_run).to upgrade_openvpn_server_app(name)
      end

      it 'upgrades the openvpn package' do
        expect(chef_run).to upgrade_package('openvpn')
      end
    end
  end

  context 'the :remove action' do
    include_context description

    it 'does not raise an error' do
      expect { chef_run }.to_not raise_error
    end
  end
end
