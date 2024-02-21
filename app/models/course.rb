class Course < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :enroll_courses
  has_many :lessons
  has_many :subjects
  has_many :contents, as: :resource
end
