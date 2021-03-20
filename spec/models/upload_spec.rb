# frozen_string_literal: true

describe Upload, type: :model do
  it 'factory should be valid' do
    upload = build :upload, :with_file

    expect(upload).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :uploadable }
  end
end
