# frozen_string_literal: true

describe Portfolio, type: :model do
  it 'factory should be valid' do
    portfolio = build :portfolio

    expect(portfolio).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:positions).class_name('Users::Position').dependent(:destroy) }
    it { is_expected.to have_many(:cashes).class_name('Portfolios::Cash').dependent(:destroy) }
    it { is_expected.to have_many(:uploads).dependent(:destroy) }
    it { is_expected.to have_many(:insights).dependent(:destroy) }
  end
end
