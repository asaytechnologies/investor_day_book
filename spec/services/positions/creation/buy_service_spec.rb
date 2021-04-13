# frozen_string_literal: true

RSpec.describe Positions::Creation::BuyService, type: :service do
  subject(:service_call) { described_class.call(args) }

  let(:args) {
    {
      portfolio:      portfolio,
      quote:          quote,
      price:          Money.new(price_cents, quote.price_currency),
      amount:         amount,
      operation_date: DateTime.now
    }
  }
  let(:portfolio) { create :portfolio }
  let(:quote) { create :quote }
  let(:price_cents) { 100 }
  let(:amount) { 1 }

  describe '.call' do
    it 'succeeds' do
      expect(service_call.success?).to eq true
    end

    it 'and creates new position' do
      expect { service_call }.to change(Users::Position, :count).by(1)
    end

    it 'and position is with buying type' do
      service_call
      position = Users::Position.last

      expect(position.selling_position).to eq false
    end
  end
end
