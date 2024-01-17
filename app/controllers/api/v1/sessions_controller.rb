class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    resource = warden.authenticate(auth_options)

    if resource
      sign_in(:user, resource)
      render json: { token: resource.authentication_token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def auth_options
    { scope: :user, recall: "#{controller_path}#new" }
  end
end
