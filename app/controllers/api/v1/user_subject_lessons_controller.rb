class Api::V1::UserSubjectLessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_subject_lesson, only: [:user_subject_lesson_contents]
  before_action :find_lesson, only: [:user_subject_lessons_for_lesson]

  def mark_user_subject_lesson_as_done
    update_user_subject_lesson_status(true, 'marked as done successfully')
  end

  def unmark_user_subject_lesson_as_done
    update_user_subject_lesson_status(false, 'unmarked as done successfully')
  end

  def user_subject_lessons_for_lesson
    subject_lessons = @lesson.subject_lessons
    user_subject_lessons = current_user.user_subject_lessons.where(subject_lesson: subject_lessons)
  
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

  def update_user_subject_lesson_status(status, message)
    user_subject_lesson = current_user.user_subject_lessons.find_or_create_by(subject_lesson_id: params[:subject_lesson_id]) do |lesson|
      lesson.done = !status
    end

    if user_subject_lesson
      user_subject_lesson.update(done: status)
      render json: { message: "User Subject lesson #{message}" }, status: :ok
    else
      Rails.logger.error "Failed to create or find User Subject lesson for subject_lesson_id: #{params[:subject_lesson_id]}"
      render json: { error: 'User Subject lesson not found or failed to create' }, status: :not_found
    end
  end

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
end
