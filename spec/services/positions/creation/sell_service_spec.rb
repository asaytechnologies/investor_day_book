# frozen_string_literal: true

RSpec.describe Positions::Creation::SellService, type: :service do
  subject(:service_call) { described_class.call(args) }

  let!(:portfolio) { create :portfolio }
  let!(:quote) { create :quote }
  let(:price_cents) { 100 }
  let(:amount) { 12 }
  let!(:args) {
    {
      portfolio: portfolio,
      quote:     quote,
      price:     Money.new(price_cents, quote.price_currency),
      amount:    amount
    }
  }

  describe '.call' do
    it 'succeed' do
      expect(service_call.success?).to eq true
    end

    it 'and creates new position' do
      expect { service_call }.to change(Users::Position, :count).by(1)
    end

    it 'and position is with selling type' do
      service_call
      position = Users::Position.last

      expect(position.selling_position).to eq true
    end

    # rubocop: disable RSpec/MultipleMemoizedHelpers
    context 'for existed positions' do
      let!(:selling_position1) {
        create :users_position, portfolio: portfolio, quote: quote, selling_position: true, amount: 10
      }
      let!(:buying_position2) {
        create :users_position, portfolio: portfolio, quote: quote, selling_position: false, amount: 10
      }
      let!(:buying_position3) { create :users_position, portfolio: portfolio, selling_position: false, amount: 20 }
      let!(:buying_position4) {
        create :users_position, portfolio: portfolio, quote: quote, selling_position: false, sold_all: true
      }
      let!(:buying_position5) {
        create :users_position, portfolio: portfolio, quote: quote, selling_position: false, amount: 20
      }

      it 'decreases amount only for buying positions for current quote', :aggregate_failures do
        service_call

        expect(selling_position1.reload.sold_amount).to eq 0
        expect(buying_position2.reload.sold_amount).to eq 10
        expect(buying_position2.sold_all).to eq true
        expect(buying_position3.reload.sold_amount).to eq 0
        expect(buying_position4.reload.sold_amount).to eq 0
        expect(buying_position5.reload.sold_amount).to eq 2
        expect(buying_position5.sold_all).to eq false
      end
    end
    # rubocop: enable RSpec/MultipleMemoizedHelpers
  end
end
