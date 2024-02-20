class Lesson < ApplicationRecord
  belongs_to :course
  has_many :subjects
  validates :name, presence: true
end
