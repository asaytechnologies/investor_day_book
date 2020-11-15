# frozen_string_literal: true

describe User, type: :model do
  it 'factory should be valid' do
    user = build :user

    expect(user).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
  end

  it 'invalid without email' do
    user = described_class.new(email: nil)
    user.valid?

    expect(user.errors[:email]).not_to eq nil
  end

  it 'invalid without password' do
    user = described_class.new(password: nil)
    user.valid?

    expect(user.errors[:password]).not_to eq nil
  end

  it 'invalid with a duplicate email' do
    described_class.create(email: 'example@gmail.com', password: 'password12')
    user = described_class.new(email: 'example@gmail.com', password: 'password12')
    user.valid?

    expect(user.errors[:email]).not_to eq nil
  end
end
