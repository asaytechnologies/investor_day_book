# frozen_string_literal: true

describe Sector, type: :model do
  it 'factory should be valid' do
    sector = build :sector

    expect(sector).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:industries).dependent(:nullify) }
    it { is_expected.to have_many(:securities).through(:industries) }
  end
end
