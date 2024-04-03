class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def enrolled_courses
    user = current_user
    enrolled_courses = user ? user.courses : []
    render json: { enrolled_courses: enrolled_courses }, status: :ok
  end

  def enroll_course
    course = Course.find_by(id: params[:course_id])
    if course
      if current_user.courses.exists?(course.id)
        render json: { error: 'User is already enrolled in this course' }, status: :unprocessable_entity
      else
        current_user.courses << course
        render json: { message: 'Successfully enrolled in the course' }, status: :created
      end
    else
      render json: { error: 'Course not found' }, status: :not_found
    end
  end
  

  def unenroll_course
    course = Course.find_by(id: params[:course_id])
    if course
      if current_user.courses.exists?(course.id)
        current_user.courses.delete(course)
        render json: { message: 'Successfully unenrolled from the course' }, status: :ok
      else
        render json: { error: 'User is not enrolled in this course' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Course not found' }, status: :not_found
    end
  end
end
