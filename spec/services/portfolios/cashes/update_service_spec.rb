# frozen_string_literal: true

describe Portfolios::Cashes::UpdateService, type: :service do
  subject(:service_call) { described_class.call(portfolios_cash: portfolios_cash, params: params) }

  let!(:portfolios_cash) { create :portfolios_cash }
  let(:amount_cents) { 100_000 }
  let(:params) { { amount_cents: amount_cents } }

  describe '.call' do
    it 'succeeds' do
      expect(service_call.success?).to eq true
    end

    it 'and updates cash' do
      expect { service_call }.to change(portfolios_cash.reload, :amount_cents).to(amount_cents)
    end
  end
end
