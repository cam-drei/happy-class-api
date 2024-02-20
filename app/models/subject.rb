class Subject < ApplicationRecord
  belongs_to :lesson
  belongs_to :course
  validates :name, presence: true
end
