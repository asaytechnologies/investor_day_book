# frozen_string_literal: true

RSpec.describe ExchangeRate, type: :model do
  it 'factory should be valid' do
    exchange_rate = build :exchange_rate

    expect(exchange_rate).to be_valid
  end
end
