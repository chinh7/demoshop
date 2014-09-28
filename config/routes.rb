Rails.application.routes.draw do
  resources :orders do
    member do
      post :make_wallet_payment_request
    end
  end

  devise_for :users
  resources :items

  namespace 'cart' do
    post :add_item
    post :remove_item
  end

  resources :quoine_tokens, only: [:new, :create] do
    collection do
      post :set_callback
    end
  end

  namespace 'callbacks' do
    post 'quoine_payments', action: :quoine_payments
  end

  get 'admin' => 'admin#index'
  get 'cart' => 'cart#index'

  root to: "home#index"
end
