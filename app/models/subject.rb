class Subject < ApplicationRecord
  validates :name, presence: true

  belongs_to :course
  has_many :subject_lessons
  has_many :lessons, through: :subject_lessons
  has_many :user_subjects
  has_many :users, through: :user_subjects
end
