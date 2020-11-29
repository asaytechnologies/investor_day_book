# frozen_string_literal: true

describe Portfolios::Cashes::Operation, type: :model do
  it 'factory should be valid' do
    operation = build :portfolios_cashes_operation

    expect(operation).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:cash).class_name('Portfolios::Cash') }
  end
end
