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

  resources :products do
    member do
      patch :product_visibility
      post :duplicate_product
    end
  end


  post   "cart_items",     to: "cart_items#create",  as: "cart_items"
  patch  "cart_items",     to: "cart_items#update",  as: "cart_item"
  delete "cart_items",     to: "cart_items#destroy", as: "remove_cart_item"

  post "cart_items/instantly", to: "cart_items#create_instantly", as: "cart_create_instantly"


  resources :orders, only: [ :show, :index, :create, :destroy, :update ] do
    member do
      get :cancel_stripe_checkout
    end
  end

  post "stripe/webhooks", to: "stripe_webhooks#create", as: "stripe_webhooks"

  resources :order_items, only: [ :create, :destroy ]

  get "cart",       to: "carts#show",        as: "cart"
  get "cart_mini",  to: "carts#mini_show",   as: "cart_mini"

  get "dashboard",              to: "dashboard#index",            as: "dashboard"
  get "dashboard/products",     to: "dashboard#products_index",   as: "dashboard_products"

  get "dashboard/orders",       to: "dashboard#orders_index",    as: "dashboard_orders"
  get "dashboard/orders/:id",   to: "dashboard#order_show",      as: "dashboard_order"

  get "dashboard/feedback_index" ,to: "dashboard#feedback_index", as: "dashboard_feedbacks"
  get "dashboard/feedback_show/:id", to: "dashboard#feedback_show", as: "dashboard_feedback_show"

  root "products#index"

  resources :feedbacks, only:  [:index, :new, :create, :destroy, :edit, :update]
  resources :wish_lists, only: [:index, :create, :destroy, :update]
end
