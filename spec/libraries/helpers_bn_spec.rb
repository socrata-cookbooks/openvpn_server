# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../libraries/helpers_bn'

describe OpenvpnServer::Helpers::BN do
  let(:param) { nil }
  let(:bn) { described_class.new(param) }

  describe '#to_s' do
    [[0, '00'], [10, '0A'], [255, 'FF'], [442, '01BA']].each do |pair|
      context "a serial of #{pair[0]}" do
        let(:param) { pair[0] }

        it "returns #{pair[1]}" do
          expect(bn.to_s).to eq(pair[1])
        end
      end
    end
  end
end
