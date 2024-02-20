class Api::V1::LessonsController < ApplicationController
  before_action :set_course

  def index
    @lessons = @course.lessons
    render json: @lessons
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
