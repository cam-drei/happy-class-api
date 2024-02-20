class Lesson < ApplicationRecord
  belongs_to :course
  has_many :enroll_lessons
  has_many :subjects
  validates :name, presence: true
end
