class SubjectLesson < ApplicationRecord
  belongs_to :subject
  belongs_to :lesson
  has_many :contents, as: :resource
  has_many :user_subject_lessons
  has_many :users, through: :user_subject_lessons
end
