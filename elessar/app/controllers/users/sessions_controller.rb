# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :configure_sign_in_params, only: [ :create ]

  private

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password ])
  end

  def respond_with(resource, _opts = {})
    render json: {
      message: "Logged in successfully.",
      user: {
        id: resource.id,
        email: resource.email
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last,
                               ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base).first
      current_user = User.find(jwt_payload["sub"])
    end

    if current_user
      render json: {
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
