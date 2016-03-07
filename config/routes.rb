Rails.application.routes.draw do
  root to: "homepages#root"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy'
  end

  namespace :api, defaults: { format: :json } do
    resources :owners

    resources :schools do
      collection do
        get 'bracket'
      end
    end

    resources :leagues do
      get 'standings'
    end

    resources :owner_schools, only: %i(create destroy)
  end
end
