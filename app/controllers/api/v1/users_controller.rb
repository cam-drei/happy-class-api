class Api::V1::UsersController < ApplicationController
  def enrolled_courses
    @user = User.find(params[:id])
    @enrolled_courses = @user.courses
    render json: { enrolled_courses: @enrolled_courses }, status: :ok
  end
end
