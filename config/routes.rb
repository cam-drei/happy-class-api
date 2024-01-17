Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post '/login', to: 'sessions#create'
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
