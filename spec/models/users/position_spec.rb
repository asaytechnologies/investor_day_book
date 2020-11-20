# frozen_string_literal: true

describe Users::Position, type: :model do
  it 'factory should be valid' do
    users_position = build :users_position

    expect(users_position).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to(:users_account).class_name('Users::Account') }
    it { is_expected.to belong_to :security }
  end
end
