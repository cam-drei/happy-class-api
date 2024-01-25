class Course < ApplicationRecord
  belongs_to :user
  has_many :enroll_courses
  validates :name, presence: true
end
