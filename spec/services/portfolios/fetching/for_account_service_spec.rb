# frozen_string_literal: true

RSpec.describe Portfolios::Fetching::ForAccountService, type: :service do
  subject(:service_call) { described_class.call(user: user) }

  let!(:user) { create :user }
  let!(:user_portfolio) { create :portfolio, user: user }
  let!(:not_user_portfolio) { create :portfolio }

  describe '.call' do
    it 'succeed' do
      expect(service_call.success?).to eq true
    end

    it 'and returns user portfolios', :aggregate_failures do
      result = service_call.result

      expect(result.size).to eq 1
      expect(result.ids.include?(user_portfolio.id)).to eq true
      expect(result.ids.include?(not_user_portfolio.id)).to eq false
    end
  end
end
