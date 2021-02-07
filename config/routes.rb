Rails.application.routes.draw do
  root "home#index"

  devise_for :admins
  resources :promotions do
    post "generate_coupons", on: :member
  end

  resources :coupons, only: [] do
    post "inactivate", on: :member
    post "activate", on: :member
  end

  resources :categories, only: %i[index show new create edit update]
end
