# frozen_string_literal: true

module Api
  module V1
    class DeploymentsController < ApplicationController
      before_action :set_deployment, only: [ :show, :update, :destroy ]

      def index
        deployments = Deployment.joins(:app).order(created_at: :desc)

        deployments = deployments.where(app_id: params[:app_id]) if params[:app_id].present?
        deployments = deployments.where(status: params[:status]) if params[:status].present?

        render json: DeploymentSerializer.render(deployments), status: :ok
      end

      def show
        render json: DeploymentSerializer.render(@deployment), status: :ok
      end

      def create
        deployment = Deployment.new(deployment_params)

        if deployment.save
          render json: DeploymentSerializer.render(deployment), status: :created
        else
          render json: { errors: deployment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @deployment.update(deployment_params)
          render json: DeploymentSerializer.render(@deployment), status: :ok
        else
          render json: { errors: @deployment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @deployment.destroy
          head :no_content
        else
          render json: { errors: @deployment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_deployment
        @deployment = Deployment.joins(:app).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Deployment not found" ] }, status: :not_found
      end

      def deployment_params
        params.require(:deployment).permit(
          :app_id, :commit_sha, :status, :build_logs, :deployed_at
        )
      end
    end
  end
end
