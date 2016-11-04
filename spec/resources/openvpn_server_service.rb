# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::openvpn_server_service' do
  include_context 'resources'

  let(:resource) { 'openvpn_server_service' }
  %i().each { |p| let(p) { nil } }
  let(:properties) { {} }
  let(:name) { 'default' }

  shared_context 'the default action (:enable, :start)' do
  end

  %i(enable disable start stop restart).each do |a|
    shared_context "the :#{a} action" do
      let(:action) { a }
    end
  end

  shared_examples_for 'any platform' do
    context 'the default action (:enable, :start)' do
      include_context description

      it 'creates an openvpn_server_service resource' do
        expect(chef_run).to enable_openvpn_server_service('default')
        expect(chef_run).to start_openvpn_server_service('default')
      end

      it 'enables the openvpn service' do
        expect(chef_run).to enable_service('openvpn')
      end

      it 'starts the openvpn service' do
        expect(chef_run).to start_service('openvpn')
      end
    end

    %i(enable disable start stop restart).each do |a|
      context "the :#{a} action" do
        include_context description

        it 'creates an openvpn_server_service resource' do
          expect(chef_run).to send("#{a}_openvpn_server_service", 'default')
        end

        it "#{a}s the openvpn service" do
          expect(chef_run).to send("#{a}_service", 'openvpn')
        end
      end
    end
  end
end
