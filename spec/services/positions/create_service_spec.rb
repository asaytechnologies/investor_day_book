# frozen_string_literal: true

RSpec.describe Positions::CreateService, type: :service do
  subject(:service_call) { described_class.call(args) }

  before do
    allow(Positions::Creation::BuyService).to receive(:call)
    allow(Positions::Creation::SellService).to receive(:call)
  end

  describe '.call' do
    context 'for buy operation' do
      let(:args) { { operation: '0' } }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and calls buy service' do
        service_call

        expect(Positions::Creation::BuyService).to have_received(:call).with(args.except(:operation))
      end
    end

    context 'for sell operation' do
      let(:args) { { operation: '1' } }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and calls sell service' do
        service_call

        expect(Positions::Creation::SellService).to have_received(:call).with(args.except(:operation))
      end
    end
  end
end
