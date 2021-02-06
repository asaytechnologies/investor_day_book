# frozen_string_literal: true

describe Users::Oauth::FindService, type: :service do
  subject(:service_call) { described_class.call(auth: auth) }

  let!(:auth) { create :oauth }

  context 'for not existed user' do
    it 'creates the user' do
      expect { service_call }.to change(User, :count).by(1)
    end

    it 'and stores attributes', :aggregate_failures do
      user = service_call.result

      expect(user.email).to eq auth.info['email']
      expect(user).to be_confirmed
    end

    it 'and creates identity' do
      expect { service_call }.to change(Identity, :count).by(1)
    end

    it 'and returns created user' do
      expect(service_call.result).to eq User.last
    end
  end

  context 'for existing user without identity' do
    let!(:user) { create(:user, email: auth['info']['email']) }

    it 'does not create user' do
      expect { service_call }.not_to change(User, :count)
    end

    it 'and creates identity' do
      expect { service_call }.to change(Identity, :count).by(1)
    end

    it 'and returns existed user' do
      expect(service_call.result).to eq user
    end
  end

  context 'for existing user with identity' do
    let!(:user) { create(:user, email: auth['info']['email']) }

    before { create :identity, user: user, provider: auth.provider, uid: auth.uid }

    it 'does not create user' do
      expect { service_call }.not_to change(User, :count)
    end

    it 'and does not create identity' do
      expect { service_call }.not_to change(Identity, :count)
    end

    it 'and returns existed user' do
      expect(service_call.result).to eq user
    end
  end
end
