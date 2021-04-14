# frozen_string_literal: true

describe Insight, type: :model do
  it 'factory should be valid' do
    insights = build :insights

    expect(insights).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :portfolio }
    it { is_expected.to belong_to :quote }
    it { is_expected.to belong_to(:insightable).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).only_integer }
  end
end
