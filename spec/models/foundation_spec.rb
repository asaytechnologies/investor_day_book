# frozen_string_literal: true

describe Foundation, type: :model do
  it 'factory should be valid' do
    foundation = build :foundation

    expect(foundation).to be_valid
  end
end
