class Subject < ApplicationRecord
  validates :name, presence: true

  belongs_to :lesson
  belongs_to :course
  has_many :contents, as: :resource
end
