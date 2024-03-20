class Api::V1::SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subject

  def mark_subject_as_selected
    if @subject.update(selected: true)
      render json: { message: 'Subject marked as selected successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark subject as selected' }, status: :unprocessable_entity
    end
  end

  def unmark_subject_as_selected
    if @subject.update(selected: false)
      render json: { message: 'Subject marked as not selected successfully' }, status: :ok
    else
      render json: { error: 'Failed to mark subject as not selected' }, status: :unprocessable_entity
    end
  end

  private

  def find_subject
    course = current_user.courses.find(params[:course_id])
    @subject = course.subjects.find(params[:subject_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subject not found' }, status: :not_found
  end
end
