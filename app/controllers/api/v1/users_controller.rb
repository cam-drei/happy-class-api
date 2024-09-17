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
        course.lessons.each do |lesson|
          unless current_user.user_lessons.exists?(lesson_id: lesson.id)
            current_user.user_lessons.create(lesson: lesson)
          end
        end
        render json: { message: 'Successfully enrolled in the course' }, status: :created
      end
    else
      render json: { error: 'Course not found' }, status: :not_found
    end
  end  

  def unenroll_course
    course = Course.find_by(id: params[:course_id])
    if course
      if current_user.courses.exists?(id: course.id)
        current_user.courses.delete(course)
        render json: { message: 'Successfully unenrolled from the course' }, status: :ok
      else
        render json: { error: 'User is not enrolled in this course' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Course not found' }, status: :not_found
    end
  end

  def user_lessons
    if params[:course_id]
      course = Course.find_by(id: params[:course_id])
      if course
        lesson_ids = course.lessons.pluck(:id)
        user_lessons = current_user.user_lessons.where(lesson_id: lesson_ids)
  
        user_lessons.each do |user_lesson|
          lesson = Lesson.find_by(id: user_lesson.lesson_id)
          next unless lesson
  
          lesson_done = lesson.subject_lessons.all? { |sl| current_user.user_subject_lessons.exists?(subject_lesson: sl, done: true) }
          user_lesson.update(done: lesson_done)
        end
  
        render json: { user_lessons: user_lessons }, status: :ok
      else
        render json: { error: 'Course not found' }, status: :not_found
      end
    else
      render json: { user_lessons: current_user.user_lessons }, status: :ok
    end
  rescue StandardError => e
    Rails.logger.error "Error: #{e.message}"
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end  

  def mark_user_lesson_as_done
    user_lesson = current_user.user_lessons.find_by(id: params[:user_lesson_id])
    if user_lesson
      user_lesson.update(done: true)
      render json: { message: 'User lesson marked as done' }, status: :ok
    else
      render json: { error: 'User lesson not found' }, status: :not_found
    end
  end

  def unmark_user_lesson_as_done
    user_lesson = current_user.user_lessons.find_by(id: params[:user_lesson_id])
    if user_lesson
      user_lesson.update(done: false)
      render json: { message: 'User lesson marked as not done' }, status: :ok
    else
      render json: { error: 'User lesson not found' }, status: :not_found
    end
  end
end
