# frozen_string_literal: true

class Api::V1::MeController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: {
      user: {
        id: current_user.id,
        email: current_user.email,
        created_at: current_user.created_at,
        sign_in_count: current_user.sign_in_count,
        current_sign_in_at: current_user.current_sign_in_at,
        last_sign_in_at: current_user.last_sign_in_at
      }
    }, status: :ok
  end
end
