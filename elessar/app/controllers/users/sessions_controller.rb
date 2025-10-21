# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  after_action :set_jwt_cookie, only: [ :create ]

  private

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
    clear_jwt_cookie
    render json: {
      message: "Logged out successfully."
    }, status: :ok
  end

  def set_jwt_cookie
    if response.headers["Authorization"].present?
      token = response.headers["Authorization"].split(" ").last
      cookies.encrypted[:jwt_token] = {
        value: token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax,
        expires: 1.day.from_now
      }
    end
  end

  def clear_jwt_cookie
    cookies.delete(:jwt_token)
  end
end
