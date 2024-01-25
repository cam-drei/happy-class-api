class Course < ApplicationRecord
  has_many :enroll_courses
  validates :name, presence: true
end
