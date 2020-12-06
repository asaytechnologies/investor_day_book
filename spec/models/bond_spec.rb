# frozen_string_literal: true

describe Bond, type: :model do
  it 'factory should be valid' do
    bond = build :bond

    expect(bond).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:industry).optional }
    it { is_expected.to belong_to(:sector).optional }
    it { is_expected.to have_many(:quotes).dependent(:destroy) }
    it { is_expected.to have_many(:positions).class_name('Users::Position').through(:quotes) }
  end
end
