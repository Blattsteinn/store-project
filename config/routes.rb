Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  
  resources :products
  
  post   "cart_items",     to: "cart_items#create",  as: "cart_items"
  patch  "cart_items",     to: "cart_items#update",  as: "cart_item"
  delete "cart_items",     to: "cart_items#destroy", as: "remove_cart_item"


  resources :orders, only: [:index, :create, :destroy]
  resources :order_items, only: [:create, :destroy]

  get "cart", to: "carts#show", as: "cart"

  get "dashboard",              to: "dashboard#index",           as: "dashboard"
  get "dashboard/products",     to: "dashboard#products_view",   as: "dashboard_products"
  get "dashboard/products/:id", to: "dashboard#product_view",    as: "dashboard_product_view"

  root "products#index"
end
