# frozen_string_literal: true

describe Bond, type: :model do
  it 'factory should be valid' do
    bond = build :bond

    expect(bond).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:quotes).class_name('Exchanges::Quote').dependent(:destroy) }
  end
end
