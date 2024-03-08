class Api::V1::SubjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :find_subject

  def index #check later
    subjects = @subject
    render json: { subjects: subjects }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subject not found' }, status: :not_found
  end

  def subject_details
    contents = @subject.contents
    render json: { contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subject not found' }, status: :not_found
  end

  def mark_subject_as_done
    if @subject.update(done: true)
      render json: { message: 'Subject marked as done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark subject as done' }, status: :unprocessable_entity
    end
  end

  def unmark_subject_as_done
    if @subject.update(done: false)
      render json: { message: 'Subject marked as not done successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark subject as not done' }, status: :unprocessable_entity
    end
  end

  private

  def find_subject
    course = current_user.courses.find(params[:course_id])
    lesson = course.lessons.find(params[:lesson_id])
    @subject = lesson.subjects.find(params[:subject_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subject not found' }, status: :not_found
  end
end
