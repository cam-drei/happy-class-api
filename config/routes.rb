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
          get 'enrolled_courses/:course_id/lessons', to: 'courses#lessons_for_course'
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subjects', to: 'lessons#subjects_for_course'
        end
      end

      resources :courses, only: [] do #use for display lessons when user not logged yet
        resources :lessons, only: [:index]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
