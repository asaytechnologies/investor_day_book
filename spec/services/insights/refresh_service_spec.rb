# frozen_string_literal: true

describe Insights::RefreshService, type: :service do
  subject(:service_call) { described_class.call(args) }

  let!(:args) { { parentable: portfolio, insightable: quote } }

  before do
    create :users_position, portfolio: portfolio, quote: quote

    create :exchange_rate, base_currency: 'RUB', rate_currency: 'RUB'
    create :exchange_rate, base_currency: 'EUR', rate_currency: 'RUB'
    create :exchange_rate, base_currency: 'USD', rate_currency: 'RUB'
  end

  describe '.call' do
    context 'without existed insights, without sector' do
      let(:portfolio) { create :portfolio }
      let(:quote) { create :quote }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and creates 2 insights' do
        expect { service_call }.to change(Insight, :count).by(2)
      end
    end

    context 'without existed insights, with sector' do
      let(:portfolio) { create :portfolio }
      let(:sector) { create :sector }
      let(:security) { create :share, sector: sector }
      let(:quote) { create :quote, security: security }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and creates 2 insights' do
        expect { service_call }.to change(Insight, :count).by(4)
      end
    end
  end
end
