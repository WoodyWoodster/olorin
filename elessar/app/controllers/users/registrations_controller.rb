# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :configure_sign_up_params, only: [ :create ]
  after_action :set_jwt_cookie, only: [ :create ]

  def create
    organization = nil
    user = nil

    ActiveRecord::Base.transaction do
      organization = Organization.new(organization_params)
      unless organization.save
        render json: {
          message: "Organization couldn't be created. #{organization.errors.full_messages.to_sentence}"
        }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      build_resource(sign_up_params.merge(organization_id: organization.id))
      user = resource

      unless user.save
        render json: {
          message: "User couldn't be created. #{user.errors.full_messages.to_sentence}"
        }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      sign_up(resource_name, user)
      respond_with user
    end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :password, :password_confirmation ])
  end

  def organization_params
    params.require(:organization).permit(:name, :subdomain)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "Signed up successfully.",
        user: {
          id: resource.id,
          email: resource.email
        }
      }, status: :ok
    else
      render json: {
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
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
end
