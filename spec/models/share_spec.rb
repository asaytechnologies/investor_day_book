# frozen_string_literal: true

describe Share, type: :model do
  it 'factory should be valid' do
    share = build :share

    expect(share).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:quotes).class_name('Exchanges::Quote').dependent(:destroy) }
  end
end
