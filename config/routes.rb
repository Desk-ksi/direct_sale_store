Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#top"
  get "how_to", to: "static_pages#how_to"
  get "how_to/user", to: "static_pages#user_how_to"
  get "how_to/shop", to:"static_pages#shop_how_to"
  get "how_to/post", to:"static_pages#post_how_to"
  get "how_to/promote", to:"static_pages#promote_how_to"
  resource :login, only: %i{ new create destroy } do
    collection do
      get :confirm
      post :verify
    end
  end
  resources :users, only: %i{ new create }
  resources :shops, only: %i{ new create index show edit update destroy} do
    collection do
      get :complete
      get :index_distance
      get :my_shops
    end
    resources :posts, only: %i{ new create index show edit update destroy } 
  end
  get "my_shops", to: "posts#my_shops"
end
