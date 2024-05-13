class Api::V1::UserSubjectsController < ApplicationController
  before_action :authenticate_user!

  def mark_user_subject_as_selected
    @user_subject.update(selected: true)
    render json: { message: 'User subject marked as selected successfully' }, status: :ok
  end

  def unmark_user_subject_as_selected
    @user_subject.update(selected: false)
    render json: { message: 'User subject marked as not selected successfully' }, status: :ok
  end

  private

  def find_course_and_subject
    @course = Course.find_by(id: params[:course_id])
    @subject = @course&.subjects&.find_by(id: params[:user_subject_id])
    unless @course && @subject
      render json: { error: 'Course or subject not found' }, status: :not_found
    end
  end

  def find_user_subject
    @user_subject = current_user.user_subjects.find_by(id: params[:user_subject_id])
    unless @user_subject
      render json: { error: 'User subject not found' }, status: :not_found
    end
  end
end
