# frozen_string_literal: true

describe Users::Position, type: :model do
  it 'factory should be valid' do
    users_position = build :users_position

    expect(users_position).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :portfolio }
    it { is_expected.to belong_to :quote }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :operation_date }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).only_integer }
  end
end
