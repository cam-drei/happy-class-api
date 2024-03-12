class Lesson < ApplicationRecord
  validates :name, presence: true

  belongs_to :course
  has_many :contents, as: :resource
  has_many :subject_lessons
  has_many :subjects, through: :subject_lessons
end
