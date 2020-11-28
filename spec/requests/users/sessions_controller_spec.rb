# frozen_string_literal: true

describe Users::SessionsController, type: :request do
  describe 'GET#new' do
    it 'renders login page' do
      get new_user_session_en_path

      expect(last_response.body).to include('Log in')
    end
  end

  describe 'POST#create' do
    let!(:user) { create :user, :unconfirmed }

    context 'for invalid data' do
      it 'redirects to login page' do
        post user_session_path(user: { email: user.email, password: '11111' })

        expect(last_response.body).to include('Log in')
      end
    end

    context 'for valid data' do
      context 'for not confirmed user' do
        it 'redirects to login page' do
          post user_session_path(user: { email: user.email, password: user.password })
          follow_redirect!

          expect(last_response.body).to include('Log in')
        end
      end

      context 'for confirmed user' do
        before { user.update(confirmed_at: DateTime.now) }

        it 'redirects to home page' do
          post user_session_path(user: { email: user.email, password: user.password })
          follow_redirect!

          expect(last_response.body).not_to include('Log in')
        end
      end
    end
  end
end
