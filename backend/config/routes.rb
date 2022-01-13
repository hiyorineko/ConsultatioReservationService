Rails.application.routes.draw do

  authenticated :user do
    namespace :users do
      get 'reserves' => 'reserves#index'
      delete 'reserve/delete/:reserve_id' => 'reserves#delete'
    end
  end
  devise_for :admins
  devise_for :experts
  devise_for :users

  get '*path', controller: 'application', action: 'render_404'
  post '*path', controller: 'application', action: 'render_404'
  delete '*path', controller: 'application', action: 'render_404'
end
