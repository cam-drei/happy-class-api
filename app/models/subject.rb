class Subject < ApplicationRecord
  validates :name, presence: true

  belongs_to :course
  has_and_belongs_to_many :lessons
  has_many :contents, as: :resource
end
