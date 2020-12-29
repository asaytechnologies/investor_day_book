# frozen_string_literal: true

describe Bonds::Coupon, type: :model do
  it 'factory should be valid' do
    bonds_coupon = build :bonds_coupon

    expect(bonds_coupon).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :quote }
  end
end
