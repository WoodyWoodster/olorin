# frozen_string_literal: true

module Api
  module V1
    class AppsController < ApplicationController
      before_action :set_app, only: [ :show, :update, :destroy ]

      # GET /api/v1/apps
      def index
        apps = App.all.order(created_at: :desc)

        # Optional filtering
        apps = apps.where(status: params[:status]) if params[:status].present?
        apps = apps.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?

        render json: AppSerializer.render(apps), status: :ok
      end

      # GET /api/v1/apps/:id
      def show
        render json: AppSerializer.render(@app), status: :ok
      end

      # POST /api/v1/apps
      def create
        app = App.new(app_params)

        if app.save
          render json: AppSerializer.render(app), status: :created
        else
          render json: { errors: app.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/apps/:id
      def update
        if @app.update(app_params)
          render json: AppSerializer.render(@app), status: :ok
        else
          render json: { errors: @app.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/apps/:id
      def destroy
        if @app.destroy
          head :no_content
        else
          render json: { errors: @app.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_app
        @app = App.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "App not found" ] }, status: :not_found
      end

      def app_params
        params.require(:app).permit(
          :name, :subdomain, :git_url, :status, :description
        )
      end
    end
  end
end
