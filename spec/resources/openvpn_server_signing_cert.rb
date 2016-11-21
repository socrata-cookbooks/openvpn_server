# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::openvpn_server_signing_cert' do
  include_context 'resources'

  let(:resource) { 'openvpn_server_signing_cert' }
  %i(path body).each { |p| let(p) { nil } }
  let(:properties) { { path: path, body: body } }
  let(:name) { '/etc/openvpn/keys/server.crt' }

  shared_context 'the default action (:create)' do
  end

  shared_context 'the :delete action' do
    let(:action) { :delete }
  end

  shared_examples_for 'any platform' do
    context 'the default action (:create)' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates an openvpn_server_signing_cert resource' do
          expect(chef_run).to create_openvpn_server_signing_cert(name)
        end

        it 'creates the cert file' do
          expect(chef_run).to create_file(path || name).with(content: body)
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden path property' do
        let(:path) { '/tmp/server.crt' }

        it_behaves_like 'any property set'
      end
    end

    context 'the :delete action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates an openvpn_server_signing_cert resource' do
          expect(chef_run).to delete_openvpn_server_signing_cert(name)
        end

        it 'deletes the cert file' do
          expect(chef_run).to delete_file(path || name)
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden path property' do
        let(:path) { '/tmp/server.crt' }

        it_behaves_like 'any property set'
      end
    end
  end
end
