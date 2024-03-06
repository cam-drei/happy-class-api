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
          get 'enrolled_courses/:course_id/lessons', to: 'courses#course_details'
          get 'enrolled_courses/:course_id/contents', to: 'courses#course_details'
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subjects', to: 'lessons#lesson_details'
          get 'enrolled_courses/:course_id/lessons/:lesson_id/contents', to: 'lessons#lesson_details'
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subjects/:subject_id/contents', to: 'subjects#subject_details'

          put 'enrolled_courses/:course_id/mark_done', to: 'courses#mark_course_as_done'
          put 'enrolled_courses/:course_id/unmark_done', to: 'courses#unmark_course_as_done'

          put 'enrolled_courses/:course_id/lessons/:lesson_id/mark_done', to: 'lessons#mark_lesson_as_done'
          put 'enrolled_courses/:course_id/lessons/:lesson_id/unmark_done', to: 'lessons#unmark_lesson_as_done'

          put 'enrolled_courses/:course_id/lessons/:lesson_id/subjects/:subject_id/mark_done', to: 'subjects#mark_subject_as_done'
          put 'enrolled_courses/:course_id/lessons/:lesson_id/subjects/:subject_id/unmark_done', to: 'subjects#unmark_subject_as_done'
        end
      end

      resources :courses, only: [] do #use for display lessons when user not logged yet
        resources :lessons, only: [:index]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
