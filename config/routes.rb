Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post '/login', to: 'sessions#create'
        delete '/logout', to: 'sessions#destroy'
      end

      post '/signup', to: 'registrations#create'

      resources :users, only: [] do
        collection do
          get 'courses', to: 'courses#index'

          get 'enrolled_courses', to: 'users#enrolled_courses'
          put 'courses/:course_id/enroll_course', to: 'users#enroll_course'
          put 'courses/:course_id/unenroll_course', to: 'users#unenroll_course'

          get 'enrolled_courses/:course_id/user_lessons', to: 'users#user_lessons'
          put 'enrolled_courses/:course_id/user_lessons/:user_lesson_id/mark_done', to: 'users#mark_user_lesson_as_done'
          put 'enrolled_courses/:course_id/user_lessons/:user_lesson_id/unmark_done', to: 'users#unmark_user_lesson_as_done'

          get 'enrolled_courses/:course_id/user_subjects', to: 'user_subjects#user_subjects_for_course'
          get 'enrolled_courses/:course_id/selected_user_subjects', to: 'user_subjects#selected_user_subjects_for_course'
          put 'enrolled_courses/:course_id/user_subjects/:user_subject_id/mark_selected', to: 'user_subjects#mark_user_subject_as_selected'
          put 'enrolled_courses/:course_id/user_subjects/:user_subject_id/unmark_selected', to: 'user_subjects#unmark_user_subject_as_selected'

          get 'enrolled_courses/:course_id/lessons', to: 'courses#lessons_for_course'
          get 'enrolled_courses/:course_id/contents', to: 'courses#contents_for_course'
          get 'enrolled_courses/:course_id/subjects', to: 'courses#subjects_for_course'
          get 'enrolled_courses/:course_id/status', to: 'courses#course_status'

          get 'enrolled_courses/:course_id/lessons/:lesson_id/contents', to: 'lessons#contents_for_lesson'

          get 'enrolled_courses/:course_id/lessons/:lesson_id/subject_lessons', to: 'subject_lessons#subject_lessons_for_lesson'
          get 'enrolled_courses/:course_id/lessons/:lesson_id/subject_lessons/:subject_lesson_id/subject_lesson_contents', to: 'subject_lessons#subject_lesson_contents'

          put 'enrolled_courses/:course_id/lessons/:lesson_id/subject_lessons/:subject_lesson_id/mark_done', to: 'subject_lessons#mark_subject_lesson_as_done'
          put 'enrolled_courses/:course_id/lessons/:lesson_id/subject_lessons/:subject_lesson_id/unmark_done', to: 'subject_lessons#unmark_subject_lesson_as_done'
        end
      end

      resources :courses, only: [:index] do #use for display lessons when user not logged yet
        resources :lessons, only: [:index]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
