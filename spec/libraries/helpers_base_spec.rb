# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/helpers_base'

describe OpenvpnServer::Helpers::Base do
  let(:test_class) do
    Class.new(described_class) do
      required :test1, :test2, :test3
      default :test4, 'test4'
    end
  end

  describe '.required' do
    it 'returns the required properties' do
      expect(test_class.required).to eq(%i(test1 test2 test3))
    end
  end

  describe '.default' do
    it 'returns the default properties' do
      expect(test_class.default).to eq(test4: 'test4')
    end
  end

  describe '#initialize' do
    let(:param) { nil }
    let(:test_obj) { test_class.new(param) }

    context 'initialized from a complete hash' do
      let(:param) { { test1: 'test1', test2: 'test2', test3: 'test3' } }

      it 'makes the properties accessible as methods' do
        expect(test_obj.test1).to eq('test1')
        expect(test_obj.test2).to eq('test2')
        expect(test_obj.test3).to eq('test3')
        expect(test_obj.test4).to eq('test4')
      end
    end

    context 'initialized from a complete hash plus an override' do
      let(:param) do
        { test1: 'test1', test2: 'test2', test3: 'test3', test4: 'testa' }
      end

      it 'makes the properties accessible as methods' do
        expect(test_obj.test1).to eq('test1')
        expect(test_obj.test2).to eq('test2')
        expect(test_obj.test3).to eq('test3')
        expect(test_obj.test4).to eq('testa')
      end
    end

    context 'initialized from an incomplete hash' do
      let(:param) { { test1: nil, test2: 'test2', test3: 'test3' } }

      it 'raises an error' do
        expect { test_obj }.to raise_error(RuntimeError)
      end
    end

    context 'initialized from a complete object' do
      let(:param) do
        double(test1: 'test1', test2: 'test2', test3: 'test3', test4: nil)
      end

      it 'makes the properties accessible as methods' do
        expect(test_obj.test1).to eq('test1')
        expect(test_obj.test2).to eq('test2')
        expect(test_obj.test3).to eq('test3')
        expect(test_obj.test4).to eq('test4')
      end
    end

    context 'initialized from a complete object plus an override' do
      let(:param) do
        double(test1: 'test1', test2: 'test2', test3: 'test3', test4: 'testa')
      end

      it 'makes the properties accessible as methods' do
        expect(test_obj.test1).to eq('test1')
        expect(test_obj.test2).to eq('test2')
        expect(test_obj.test3).to eq('test3')
        expect(test_obj.test4).to eq('testa')
      end
    end

    context 'initialized from an incomplete object' do
      let(:param) do
        double(test1: nil, test2: 'test2', test3: 'test3', test4: nil)
      end

      it 'raises an error' do
        expect { test_obj }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#process_requireds!' do
    let(:param) { { test1: 'test1', test2: 'test2', test3: 'test3' } }
    let(:test_obj) do
      c = test_class.new(param)
      c.send(:process_requireds!, param)
      c
    end

    it 'processes the required items' do
      expect(test_obj.test1).to eq('test1')
      expect(test_obj.test2).to eq('test2')
      expect(test_obj.test3).to eq('test3')
    end
  end

  describe '#process_defaults' do
    let(:param) { { test1: 'test1', test2: 'test2', test3: 'test3' } }
    let(:test_obj) do
      c = test_class.new(param)
      c.send(:process_defaults!, param)
      c
    end

    it 'processes the default items' do
      expect(test_obj.test4).to eq('test4')
    end
  end
end
