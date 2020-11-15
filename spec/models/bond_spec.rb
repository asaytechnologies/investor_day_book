# frozen_string_literal: true

describe Bond, type: :model do
  it 'factory should be valid' do
    bond = build :bond

    expect(bond).to be_valid
  end
end
