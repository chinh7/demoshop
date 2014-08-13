Rails.application.routes.draw do
  devise_for :users
  resources :items

  namespace 'cart' do
    post :add_item
    post :remove_item
  end

  get 'cart' => 'cart#index'

  root to: "home#index"
end
