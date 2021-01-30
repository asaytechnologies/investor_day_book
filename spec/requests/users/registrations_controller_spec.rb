# frozen_string_literal: true

describe Users::RegistrationsController, type: :request do
  describe 'GET#new' do
    it 'renders login page' do
      get new_user_registration_en_path

      expect(last_response.body).to include('Sign up')
    end
  end

  describe 'POST#create' do
    context 'for invalid data' do
      context 'for short password' do
        let(:params) { { email: Faker::Internet.email, password: '1', password_confirmation: '1' } }

        it 'does not create user' do
          expect {
            post user_registration_en_path(user: params)
          }.not_to change(User, :count)
        end
      end

      context 'for not matched passwords' do
        let(:params) { { email: Faker::Internet.email, password: '2', password_confirmation: '1' } }

        it 'does not create user' do
          expect {
            post user_registration_en_path(user: params)
          }.not_to change(User, :count)
        end
      end

      context 'for existed user' do
        let!(:user) { create :user }
        let(:params) { { email: user.email, password: '1', password_confirmation: '1' } }

        it 'does not create user' do
          expect {
            post user_registration_en_path(user: params)
          }.not_to change(User, :count)
        end
      end
    end

    context 'for valid data' do
      let(:params) {
        { email: Faker::Internet.email, password: 'User123qwE!!@', password_confirmation: 'User123qwE!!@' }
      }

      it 'creates user' do
        expect {
          post user_registration_en_path(user: params)
        }.to change(User, :count).by(1)
      end

      it 'and redirects to confirm page' do
        post user_registration_en_path(user: params)

        expect(last_response.location).to include('users/confirmation/check')
      end
    end
  end
end
