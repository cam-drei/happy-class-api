Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post '/login', to: 'sessions#create'
      end

      resources :users, only: [] do
        collection do
          get 'enrolled_courses', to: 'users#enrolled_courses' #ok
          get 'enrolled_courses/:course_id/lessons', to: 'courses#lessons_for_course' #ok
          get 'enrolled_courses/:course_id/contents', to: 'courses#contents_for_course' #ok

          get 'enrolled_courses/:course_id/lessons/:lesson_id/contents', to: 'lessons#contents_for_lesson' #ok
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subjects', to: 'lessons#subjects_for_lesson' #ok
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subject_lessons', to: 'lessons#subject_lessons_for_lesson' #ok
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subject_lesson_contents', to: 'lessons#subject_lesson_contents_for_lesson' #ok

          # get 'enrolled_courses/:course_id/lessons/:lesson_id/subjects/:subject_id/contents', to: 'subjects#subject_details'

          get 'enrolled_courses/:course_id/lessons/:lesson_id/subjects', to: 'subjects#index' #check later

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
