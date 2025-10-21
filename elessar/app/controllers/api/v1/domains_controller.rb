# frozen_string_literal: true

module Api
  module V1
    class DomainsController < ApplicationController
      before_action :set_domain, only: [ :show, :update, :destroy ]

      # GET /api/v1/domains
      def index
        domains = Domain.joins(:app).order(created_at: :desc)

        # Optional filtering
        domains = domains.where(app_id: params[:app_id]) if params[:app_id].present?

        render json: DomainSerializer.render(domains), status: :ok
      end

      # GET /api/v1/domains/:id
      def show
        render json: DomainSerializer.render(@domain), status: :ok
      end

      # POST /api/v1/domains
      def create
        domain = Domain.new(domain_params)

        if domain.save
          render json: DomainSerializer.render(domain), status: :created
        else
          render json: { errors: domain.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/domains/:id
      def update
        if @domain.update(domain_params)
          render json: DomainSerializer.render(@domain), status: :ok
        else
          render json: { errors: @domain.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/domains/:id
      def destroy
        if @domain.destroy
          head :no_content
        else
          render json: { errors: @domain.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_domain
        @domain = Domain.joins(:app).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Domain not found" ] }, status: :not_found
      end

      def domain_params
        params.require(:domain).permit(
          :app_id, :hostname, :ssl_enabled, :verified_at
        )
      end
    end
  end
end
