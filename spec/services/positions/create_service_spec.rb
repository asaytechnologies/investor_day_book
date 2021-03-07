# frozen_string_literal: true

RSpec.describe Positions::CreateService, type: :service do
  subject(:service_call) { described_class.call(args) }

  let(:service_result) { double }
  let!(:position) { create :users_position }

  before do
    allow(Positions::Creation::BuyService).to receive(:call).and_return(service_result)
    allow(Positions::Creation::SellService).to receive(:call).and_return(service_result)

    allow(service_result).to receive(:result).and_return(position)
  end

  describe '.call' do
    context 'for buy operation' do
      let(:args) { { operation: 0 } }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and calls buy service' do
        service_call

        expect(Positions::Creation::BuyService).to(
          have_received(:call).with(args.except(:operation).merge(operation_date: nil))
        )
      end
    end

    context 'for sell operation' do
      let(:args) { { operation: 1 } }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and calls sell service' do
        service_call

        expect(Positions::Creation::SellService).to(
          have_received(:call).with(args.except(:operation).merge(operation_date: nil))
        )
      end
    end
  end
end
