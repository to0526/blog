Rails.application.routes.draw do
  # 公開側
  root "posts#index"
  resources :posts, only: [ :show ]

  # 管理側
  namespace :admin do
    resources :posts, only: [ :new, :create, :edit, :update, :destroy ]
  end

  # 認証
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
