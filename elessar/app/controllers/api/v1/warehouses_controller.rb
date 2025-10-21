# frozen_string_literal: true

module Api
  module V1
    class WarehousesController < ApplicationController
      before_action :set_warehouse, only: [ :show, :update, :destroy ]

      # GET /api/v1/warehouses
      def index
        warehouses = Warehouse.includes(:addresses).all.order(created_at: :desc)

        # Optional filtering
        warehouses = warehouses.where(is_active: params[:is_active]) if params[:is_active].present?
        warehouses = warehouses.where("name LIKE ? OR code LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?

        render json: WarehouseSerializer.render(warehouses), status: :ok
      end

      # GET /api/v1/warehouses/:id
      def show
        render json: WarehouseSerializer.render(@warehouse), status: :ok
      end

      # POST /api/v1/warehouses
      def create
        warehouse = Warehouse.new(warehouse_params)

        if warehouse.save
          render json: WarehouseSerializer.render(warehouse), status: :created
        else
          render json: { errors: warehouse.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/warehouses/:id
      def update
        if @warehouse.update(warehouse_params)
          render json: WarehouseSerializer.render(@warehouse), status: :ok
        else
          render json: { errors: @warehouse.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/warehouses/:id
      def destroy
        if @warehouse.destroy
          head :no_content
        else
          render json: { errors: @warehouse.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_warehouse
        @warehouse = Warehouse.includes(:addresses).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Warehouse not found" ] }, status: :not_found
      end

      def warehouse_params
        params.require(:warehouse).permit(:code, :name, :is_active)
      end
    end
  end
end
