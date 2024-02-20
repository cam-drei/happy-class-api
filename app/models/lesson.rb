class Lesson < ApplicationRecord
  belongs_to :course
  has_many :enroll_lessons
  validates :name, presence: true
end
