# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::openvpn_server_static_key' do
  include_context 'resources'

  let(:resource) { 'openvpn_server_static_key' }
  %i(path).each { |p| let(p) { nil } }
  let(:properties) { { path: path } }
  let(:name) { '/etc/openvpn/keys/static.key' }

  shared_context 'the default action (:create)' do
  end

  shared_context 'the :delete action' do
    let(:action) { :delete }
  end

  shared_examples_for 'any platform' do
    context 'the default action (:create)' do
      include_context description

      shared_examples_for 'any property set' do
        it 'generates the static key' do
          expect(chef_run).to run_execute('Generate the OpenVPN static key')
            .with(command: "openvpn --genkey --secret #{path || name}",
                  creates: path || name,
                  sensitive: true)
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden path property' do
        let(:path) { '/tmp/static.key' }

        it_behaves_like 'any property set'
      end
    end

    context 'the :delete action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'deletes the static key' do
          expect(chef_run).to delete_file(path || name)
        end
      end

      context 'all default properties' do
        it_behaves_like 'any property set'
      end

      context 'an overridden path property' do
        let(:path) { '/tmp/static.key' }

        it_behaves_like 'any property set'
      end
    end
  end
end
