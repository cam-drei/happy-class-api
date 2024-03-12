class SubjectLesson < ApplicationRecord
  belongs_to :subject
  belongs_to :lesson
  has_many :contents, as: :resource
end
