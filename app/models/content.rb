class Content < ApplicationRecord
  validates :video_link, :document_link, url: true
  validates :resource_type, inclusion: { in: %w(Course Lesson Subject) }
  validates :resource_type_id, presence: true, numericality: { integer: true }

  belongs_to :resource, polymorphic: true
end
