Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "home#index"

  resources :promotions do
    post "generate_coupons", on: :member
  end

  resources :categories, only: %i[index show new create edit update]
end
