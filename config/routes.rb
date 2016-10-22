Rails.application.routes.draw do
  get 'notifications/index'

  get 'top/index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  
  root 'top#index'
  
  resources :topics do
    resources :comments
  end
  
  resources :comments, only: [:edit, :update, :destroy]
  
  resources :users, only: [:index, :show, :edit, :update]
  
  resources :relationships, only: [:create, :destroy]
  
  resources :conversations do
    resources :messages
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
