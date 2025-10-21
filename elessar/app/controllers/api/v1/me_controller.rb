# frozen_string_literal: true

class Api::V1::MeController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { user: UserSerializer.render_as_hash(current_user) }, status: :ok
  end
end
