# frozen_string_literal: true

module Api
  module V1
    class AddonsController < ApplicationController
      before_action :set_addon, only: [ :show, :update, :destroy ]

      # GET /api/v1/addons
      def index
        addons = Addon.joins(:app).order(created_at: :desc)

        # Optional filtering
        addons = addons.where(app_id: params[:app_id]) if params[:app_id].present?
        addons = addons.where(addon_type: params[:addon_type]) if params[:addon_type].present?
        addons = addons.where(status: params[:status]) if params[:status].present?

        render json: AddonSerializer.render(addons), status: :ok
      end

      # GET /api/v1/addons/:id
      def show
        render json: AddonSerializer.render(@addon), status: :ok
      end

      # POST /api/v1/addons
      def create
        addon = Addon.new(addon_params)

        if addon.save
          render json: AddonSerializer.render(addon), status: :created
        else
          render json: { errors: addon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/addons/:id
      def update
        if @addon.update(addon_params)
          render json: AddonSerializer.render(@addon), status: :ok
        else
          render json: { errors: @addon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/addons/:id
      def destroy
        if @addon.destroy
          head :no_content
        else
          render json: { errors: @addon.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_addon
        @addon = Addon.joins(:app).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Addon not found" ] }, status: :not_found
      end

      def addon_params
        params.require(:addon).permit(
          :app_id, :addon_type, :name, :connection_string, :status, :config
        )
      end
    end
  end
end
