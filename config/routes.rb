Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'logout', to: 'users/sessions#destroy'
    get 'users', to: 'users/registrations#new'
  end
  
  #location_sharings controller
  get 'share_new_location', to: 'location_sharings#share_new_location'
  post 'save_new_shared_location', to: 'location_sharings#save_new_shared_location'
  get 'show_location', to: 'location_sharings#show_location'
  post 'delete_location', to: 'location_sharings#delete_location'
  post 'share_old_location', to: 'location_sharings#share_old_location'

  #home controller
  root to: "home#index"
  get 'users_list', to: 'home#users_list'
  get 'location_shared_with_me', to: 'home#location_shared_with_me'
  get ':username', to: 'home#publicly_shared_location_by_user'
end