# frozen_string_literal: true

require 'que/web'

Rails.application.routes.draw do
  mount Que::Web => '/que'

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

    resources :uploads, only: %i[create]

    root to: 'welcome#index'
  end
end
