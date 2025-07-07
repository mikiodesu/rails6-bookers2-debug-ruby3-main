Rails.application.routes.draw do

  get 'searches/search'
  root to: "homes#top"
  get 'home/about', to: "homes#about"

  devise_for :users

  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
    resource :favorite, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update]

  resources :book, only: [:new, :create, :index, :show, :destroy] do
    resources :post_comments, only: [:create]
  end

  resources :relationships, only: [:create, :destroy]
end