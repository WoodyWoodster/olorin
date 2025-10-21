# frozen_string_literal: true

module Api
  module V1
    class EnvVarsController < ApplicationController
      before_action :set_env_var, only: [ :show, :update, :destroy ]

      # GET /api/v1/env_vars
      def index
        env_vars = EnvVar.joins(:app).order(key: :asc)

        # Optional filtering
        env_vars = env_vars.where(app_id: params[:app_id]) if params[:app_id].present?

        render json: EnvVarSerializer.render(env_vars), status: :ok
      end

      # GET /api/v1/env_vars/:id
      def show
        render json: EnvVarSerializer.render(@env_var), status: :ok
      end

      # POST /api/v1/env_vars
      def create
        env_var = EnvVar.new(env_var_params)

        if env_var.save
          render json: EnvVarSerializer.render(env_var), status: :created
        else
          render json: { errors: env_var.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/env_vars/:id
      def update
        if @env_var.update(env_var_params)
          render json: EnvVarSerializer.render(@env_var), status: :ok
        else
          render json: { errors: @env_var.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/env_vars/:id
      def destroy
        if @env_var.destroy
          head :no_content
        else
          render json: { errors: @env_var.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_env_var
        @env_var = EnvVar.joins(:app).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Environment variable not found" ] }, status: :not_found
      end

      def env_var_params
        params.require(:env_var).permit(
          :app_id, :key, :value
        )
      end
    end
  end
end
