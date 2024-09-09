class Api::V1::UserSubjectLessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_subject_lesson, only: [:mark_user_subject_lesson_as_done, :unmark_user_subject_lesson_as_done, :user_subject_lesson_contents]
  before_action :find_lesson, only: [:user_subject_lessons_for_lesson]

  def mark_user_subject_lesson_as_done
    user_subject_lesson = current_user.user_subject_lessons.find_by(subject_lesson_id: params[:subject_lesson_id])
  
    if user_subject_lesson
      user_subject_lesson.update(done: true)
      render json: { message: 'User Subject lesson marked as done successfully' }, status: :ok
    else
      render json: { error: 'User Subject lesson not found' }, status: :not_found
    end
  end

  def unmark_user_subject_lesson_as_done
    user_subject_lesson = current_user.user_subject_lessons.find_by(subject_lesson_id: params[:subject_lesson_id])
  
    if user_subject_lesson
      user_subject_lesson.update(done: false)
      render json: { message: 'User Subject lesson unmarked as not done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark user subject lesson as not done' }, status: :not_found
    end
  end

  def user_subject_lessons_for_lesson
    subject_lessons = @lesson.subject_lessons
    user_subject_lessons = current_user.user_subject_lessons.where(subject_lesson: subject_lessons)
    
    Rails.logger.debug { "Lesson: #{@lesson.id}" }
    Rails.logger.debug { "Subject Lessons: #{subject_lessons.to_json}" }
    Rails.logger.debug { "User Subject Lessons: #{user_subject_lessons.to_json}" }
    Rails.logger.debug { "Current User: #{current_user.id}" }
    Rails.logger.debug { "Current User's Subject Lessons: #{current_user.user_subject_lessons.to_json}" }
  
    render json: {
      subject_lessons: subject_lessons.as_json(include: :subject),
      user_subject_lessons: user_subject_lessons.as_json
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lessons not found' }, status: :not_found
  end

  def user_subject_lesson_contents
    contents = @user_subject_lesson.subject_lesson.contents
    render json: { contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Contents not found' }, status: :not_found
  end

  private

  def find_user_subject_lesson
    @user_subject_lesson = current_user.user_subject_lessons.find_by(subject_lesson_id: params[:subject_lesson_id])
    render json: { error: 'Subject lesson not found' }, status: :not_found unless @user_subject_lesson
  end

  def find_lesson
    course = current_user.courses.find(params[:course_id])
    @lesson = course.lessons.find(params[:lesson_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Lesson not found' }, status: :not_found
  end

  # private

  # def find_user_subject_lesson
  #   @user_subject_lesson = current_user.user_subject_lessons.find_or_initialize_by(subject_lesson_id: params[:subject_lesson_id])
  # rescue ActiveRecord::RecordNotFound
  #   render json: { error: 'Subject lesson not found' }, status: :not_found
  # end
end
