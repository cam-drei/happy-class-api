Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post '/login', to: 'sessions#create'
      end

      resources :users, only: [] do
        collection do
          get 'enrolled_courses', to: 'users#enrolled_courses'
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
