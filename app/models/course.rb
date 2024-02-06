class Course < ApplicationRecord
  belongs_to :user
  has_many :enroll_courses
  has_many :lesson
  validates :name, presence: true
end
