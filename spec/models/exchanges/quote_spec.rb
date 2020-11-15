# frozen_string_literal: true

describe Exchanges::Quote, type: :model do
  it 'factory should be valid' do
    quote = build :quote

    expect(quote).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :exchange }
    it { is_expected.to belong_to :securitiable }
  end

  it { is_expected.to monetize(:price) }
end
