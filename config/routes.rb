Rails.application.routes.draw do
  root "home#index"

  devise_for :admins
  resources :promotions do
    member do
      post "generate_coupons"
      post "approve"
    end
  end

  resources :coupons, only: [] do
    post "inactivate", on: :member
    post "activate", on: :member
  end

  resources :categories, only: %i[index show new create edit update]
end
