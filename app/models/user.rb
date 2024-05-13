class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         :token_authenticatable

  before_save :ensure_authentication_token

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 4 }
  validates :password_confirmation, presence: true

  has_many :enroll_courses
  has_many :courses, through: :enroll_courses
  has_many :user_lessons
  has_many :lessons, through: :user_lessons
  has_many :user_subjects
  has_many :subjects, through: :user_subjects

  def user_subjects_for_course(course_id)
    enrolled_course = enroll_courses.find_by(course_id: course_id)
    return [] unless enrolled_course

    enrolled_course.course.subjects
  end

  private

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.exists?(authentication_token: token)
    end
  end
end
