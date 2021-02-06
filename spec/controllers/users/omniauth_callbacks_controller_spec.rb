# frozen_string_literal: true

describe Users::OmniauthCallbacksController, type: :controller do
  it { is_expected.to use_before_action :perform_authentication }

  describe 'google_oauth2' do
    context 'without info from provider' do
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = nil

        get 'google_oauth2'
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end

      it 'and sets flash message with error' do
        expect(request.flash[:error]).to eq 'Access Error'
      end
    end

    context 'without email in info from provider' do
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = google_invalid_hash

        get 'google_oauth2'
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end

      it 'and sets flash message with manifesto_username' do
        expect(request.flash[:manifesto_username]).to eq true
      end
    end

    context 'with info from provider' do
      before do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = google_hash
      end

      context 'for new user' do
        it 'redirects to analytics path' do
          get 'google_oauth2', params: { locale: 'en' }

          expect(response).to redirect_to analytics_en_path
        end
      end

      context 'for existed user' do
        before { create :user, email: 'example_google@xyze.it' }

        it 'redirects to analytics path' do
          get 'google_oauth2', params: { locale: 'en' }

          expect(response).to redirect_to analytics_en_path
        end
      end
    end
  end
end
