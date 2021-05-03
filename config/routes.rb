# frozen_string_literal: true

require 'que/web'

Rails.application.routes.draw do
  mount Que::Web => '/que'

  get '/sitemap' => 'sitemaps#index'

  namespace :api do
    namespace :v1 do
      resources :portfolios, only: %i[index create destroy] do
        post :clear, on: :member
      end
      resources :insights, only: %i[index]

      namespace :quotes do
        resources :search, only: %i[index]
      end
      namespace :users do
        resources :positions, only: %i[index create destroy]
      end
      namespace :portfolios do
        resources :cashes, only: %i[update]

        namespace :cashes do
          resources :incomes, only: %i[index]
        end
      end
    end
  end

  devise_for :users, skip: %i[session registration password confirmation], controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  localized do
    devise_for :users,
               skip:        %i[omniauth_callbacks confirmation registration],
               path_names:  { sign_in: 'login', sign_out: 'logout' },
               controllers: { sessions: 'users/sessions' }

    as :user do
      get 'users/confirmation' => 'users/confirmations#show', :as => :user_confirmation
      get 'users/confirmation/check' => 'users/confirmations#check', :as => :check_confirmations

      get 'users/signup' => 'users/registrations#new', :as => :new_user_registration
      post 'users' => 'users/registrations#create', :as => :user_registration
    end

    resources :portfolios, only: %i[index]
    resources :analytics, only: %i[index]
    resources :operations, only: %i[index]

    root to: 'welcome#index'
  end
end
