class Api::V1::UserSubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course_and_subject, only: [:mark_user_subject_as_selected, :unmark_user_subject_as_selected]
  before_action :find_or_create_user_subject, only: [:mark_user_subject_as_selected, :unmark_user_subject_as_selected]

  def mark_user_subject_as_selected
    @user_subject.update(selected: true)
    render json: { message: 'User subject marked as selected successfully' }, status: :ok
  end

  def unmark_user_subject_as_selected
    @user_subject.update(selected: false)
    render json: { message: 'User subject marked as not selected successfully' }, status: :ok
  end

  def user_subjects_for_course
    course_id = params[:course_id]
    if course_id.present?
      user_subjects = current_user.user_subjects_for_course(course_id)
      render json: { user_subjects: user_subjects }, status: :ok
    else
      render json: { error: 'Course ID is missing' }, status: :unprocessable_entity
    end
  end

  def selected_user_subjects_for_course
    course_id = params[:course_id]
    if course_id.present?
      selected_user_subjects = current_user.selected_user_subjects_for_course(course_id)
      render json: { selected_user_subjects: selected_user_subjects }, status: :ok
    else
      render json: { error: 'Course ID is missing' }, status: :unprocessable_entity
    end
  end

  private

  def find_course_and_subject
    @course = Course.find_by(id: params[:course_id])
    @subject = @course&.subjects&.find_by(id: params[:subject_id])
    unless @course && @subject
      render json: { error: 'Course or subject not found' }, status: :not_found
    end
  end

  def find_or_create_user_subject
    @user_subject = current_user.user_subjects.find_or_create_by(subject_id: params[:subject_id])

    if @user_subject.nil?
      render json: { error: 'User subject not found and could not be created', user_email: current_user.email, subject_id: params[:subject_id] }, status: :not_found
    end
  end
end
