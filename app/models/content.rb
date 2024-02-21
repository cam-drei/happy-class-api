class Content < ApplicationRecord
  validates :video_link, :document_link, url: true, allow_blank: true
  validates :resource_type, inclusion: { in: %w(Course Lesson Subject) }
  validates :resource_id, presence: true, numericality: { integer: true }

  belongs_to :resource, polymorphic: true
end
