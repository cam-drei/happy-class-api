class Api::V1::SubjectsController < ApplicationController
  before_action :authenticate_user!

  def subject_details
    course = current_user.courses.find(params[:course_id])
    lesson = course.lessons.find(params[:lesson_id])
    subject = lesson.subjects.find(params[:subject_id])
    contents = subject.contents
    render json: { contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subject not found' }, status: :not_found
  end
end
