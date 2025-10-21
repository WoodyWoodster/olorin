# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :set_current_tenant

  private

  def set_current_tenant
    if current_user
      Current.user = current_user
      Current.organization = current_user.organization
    end
  end
end
