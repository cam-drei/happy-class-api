class UserSubjectLesson < ApplicationRecord
  belongs_to :user
  belongs_to :subject_lesson
end
