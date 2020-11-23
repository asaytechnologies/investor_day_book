# frozen_string_literal: true

describe Portfolio, type: :model do
  it 'factory should be valid' do
    portfolio = build :portfolio

    expect(portfolio).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:positions).class_name('Users::Position').dependent(:destroy) }
  end
end
