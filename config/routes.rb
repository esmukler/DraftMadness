Rails.application.routes.draw do
  root to: "homepages#root"

  resources :users, except: [:show]
  namespace :api, defaults: { format: :json } do
    resources :users, only: [:index, :show]
    resources :owners
    resources :schools
  end
end
