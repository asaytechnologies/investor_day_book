# frozen_string_literal: true

describe ActiveType, type: :model do
  it 'factory should be valid' do
    active_type = build :active_type, :share

    expect(active_type).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    xit { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to have_many(:insights).dependent(:destroy) }
  end
end
