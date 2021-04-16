# frozen_string_literal: true

describe Insight, type: :model do
  it 'factory should be valid' do
    insight = build :insight

    expect(insight).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :parentable }
    it { is_expected.to belong_to :insightable }
  end
end
