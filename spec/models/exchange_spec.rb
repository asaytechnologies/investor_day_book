# frozen_string_literal: true

describe Exchange, type: :model do
  it 'factory should be valid' do
    exchange = build :exchange

    expect(exchange).to be_valid
  end
end
