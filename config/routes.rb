Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about"
  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end
  get "/search", to: "searches#search"
  get "tag_searches/search" => "tag_searches#search"
  resources :chats, only: [:show, :create, :destroy]
  
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
end
