Rails.application.routes.draw do

  root 'main#index'

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'sign_in' => 'devise/sessions#new'
    get 'sign_up' => 'devise/registrations#new'
  end

  match '/users/:id/finish_signup' => 'user#finish_signup', via: [:get, :patch], :as => :finish_signup

  get 'users' => 'user#index'
  get 'users/:id' => 'user#show', as: :user

  resources :conversations, only: [:index, :new, :create] do
    resources :messages, only: [:index, :create]
  end

  mount ActionCable.server => '/cable'

end
