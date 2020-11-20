# frozen_string_literal: true

describe Industry, type: :model do
  it 'factory should be valid' do
    industry = build :industry

    expect(industry).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:sector).optional }
    it { is_expected.to have_many(:securities).dependent(:nullify) }
  end
end
