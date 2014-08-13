Rails.application.routes.draw do
  devise_for :users
  resources :items

  namespace 'cart' do
    post :add_item
  end

  root to: "home#index"
end
