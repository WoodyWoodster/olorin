# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :set_company, only: [ :show, :update, :destroy ]

      # GET /api/v1/companies
      def index
        companies = Company.includes(:contacts, :addresses).all.order(created_at: :desc)

        # Optional filtering
        companies = companies.where(company_type: params[:company_type]) if params[:company_type].present?
        companies = companies.where(is_active: params[:is_active]) if params[:is_active].present?
        companies = companies.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?

        render json: CompanySerializer.render(companies), status: :ok
      end

      # GET /api/v1/companies/:id
      def show
        render json: CompanySerializer.render(@company), status: :ok
      end

      # POST /api/v1/companies
      def create
        company = Company.new(company_params)

        if company.save
          render json: CompanySerializer.render(company), status: :created
        else
          render json: { errors: company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/companies/:id
      def update
        if @company.update(company_params)
          render json: CompanySerializer.render(@company), status: :ok
        else
          render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/companies/:id
      def destroy
        if @company.destroy
          head :no_content
        else
          render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_company
        @company = Company.includes(:contacts, :addresses).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Company not found" ] }, status: :not_found
      end

      def company_params
        params.require(:company).permit(
          :name, :company_type, :tax_id, :website, :phone, :email, :is_active
        )
      end
    end
  end
end
