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

  it { is_expected.to monetize(:price) }
end
