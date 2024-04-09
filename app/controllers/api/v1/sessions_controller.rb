class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_by(email: params[:email])
    if user && user.valid_password?(params[:password])
      sign_in(user)
      render json: {
        token: user.authentication_token,
        user: user.as_json(only: [:id, :email])
      }
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    sign_out(current_user)
    render json: { message: 'Logged out successfully' }
  end
end
