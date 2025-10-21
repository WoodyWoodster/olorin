Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # API routes
  namespace :api do
    # Authentication endpoints under /api/auth
    scope :auth do
      devise_for :users, singular: :user, path: "", controllers: {
        sessions: "users/sessions",
        registrations: "users/registrations"
      }, path_names: {
        sign_in: "login",
        sign_out: "logout",
        registration: "signup"
      }, skip: [ :passwords, :confirmations, :unlocks ]
    end

    namespace :v1 do
      get "me", to: "me#show"

      resources :apps
      resources :deployments
      resources :addons
      resources :domains
      resources :env_vars
    end
  end

  # ActionCable endpoint for WebSocket connections
  mount ActionCable.server => '/cable'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
