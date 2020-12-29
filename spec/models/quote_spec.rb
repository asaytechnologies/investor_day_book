# frozen_string_literal: true

describe Quote, type: :model do
  it 'factory should be valid' do
    quote = build :quote

    expect(quote).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :security }
    it { is_expected.to have_many(:positions).class_name('Users::Position').dependent(:destroy) }
    it { is_expected.to have_many(:coupons).class_name('Bonds::Coupon').dependent(:destroy) }
  end

  it { is_expected.to monetize(:price) }
end
