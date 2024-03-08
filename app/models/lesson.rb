class Lesson < ApplicationRecord
  validates :name, presence: true

  belongs_to :course
  has_and_belongs_to_many :subjects
  has_many :contents, as: :resource
end
