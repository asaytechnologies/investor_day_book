# frozen_string_literal: true

describe Users::Account, type: :model do
  it 'factory should be valid' do
    users_account = build :users_account

    expect(users_account).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end
end
