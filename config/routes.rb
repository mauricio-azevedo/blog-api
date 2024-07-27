Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resource :tokens, only: [:create], path: 'tokens/refresh'

  resources :posts, only: [:index, :show, :create, :update, :destroy], defaults: { format: :json } do
    resources :comments, only: [:index, :show, :create, :update, :destroy], defaults: { format: :json }
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root 'welcome#index'
end
