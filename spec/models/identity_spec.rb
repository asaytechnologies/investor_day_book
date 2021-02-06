# frozen_string_literal: true

describe Identity, type: :model do
  it { is_expected.to belong_to :user }

  it 'factory should be valid' do
    identity = build :identity

    expect(identity).to be_valid
  end

  describe '.find_with_oauth' do
    let(:oauth) { create :oauth }

    context 'for unexisted identity' do
      it 'returns nil' do
        expect(described_class.find_with_oauth(oauth)).to eq nil
      end
    end

    context 'for existed identity' do
      let!(:identity) { create :identity, uid: oauth.uid }

      it 'returns identity object' do
        expect(described_class.find_with_oauth(oauth)).to eq identity
      end
    end
  end
end
