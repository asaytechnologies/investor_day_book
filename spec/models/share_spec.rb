# frozen_string_literal: true

describe Share, type: :model do
  it 'factory should be valid' do
    share = build :share

    expect(share).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:industry).optional }
    it { is_expected.to have_many(:quotes).dependent(:destroy) }
    it { is_expected.to have_many(:positions).class_name('Users::Position').through(:quotes) }
  end
end
