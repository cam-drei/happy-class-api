class Course < ApplicationRecord
  belongs_to :user
  has_many :enroll_courses
  has_many :lessons
  has_many :subjects
  validates :name, presence: true
end
