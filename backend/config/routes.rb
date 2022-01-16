Rails.application.routes.draw do
  get '/' => redirect('/users/sign_in')
  authenticated :user do
    namespace :users do
      get 'reserves' => 'reserves#index'
      delete 'reserve/delete/:reserve_id' => 'reserves#delete'
      get 'reserve_register' => 'reserve_register#index'
      get 'reserve_register/confirm' => 'reserve_register#confirm'
      post 'reserve_register' => 'reserve_register#register'
    end
  end
  authenticated :expert do
    namespace :experts do
      get 'profile' => 'profile#edit'
      patch 'profile' => 'profile#update'
      get 'reserves' => 'reserves#index'
      get 'reservable_frame_register' => 'reservable_frame_register#index'
      post 'reservable_frame_register' => 'reservable_frame_register#register'
    end
  end
  devise_for :admins
  devise_for :experts
  devise_for :users

  get '*path', controller: 'application', action: 'render_404'
  post '*path', controller: 'application', action: 'render_404'
  delete '*path', controller: 'application', action: 'render_404'
  patch '*path', controller: 'application', action: 'render_404'
end
