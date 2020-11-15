# frozen_string_literal: true

describe Foundation, type: :model do
  it 'factory should be valid' do
    foundation = build :foundation

    expect(foundation).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:quotes).class_name('Exchanges::Quote').dependent(:destroy) }
    it { is_expected.to have_many(:positions).class_name('Users::Position').dependent(:destroy) }
  end
end
