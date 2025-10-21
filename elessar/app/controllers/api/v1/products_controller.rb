# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [ :show, :update, :destroy ]

      # GET /api/v1/products
      def index
        products = Product.all.order(created_at: :desc)

        # Optional filtering
        products = products.where(product_type: params[:product_type]) if params[:product_type].present?
        products = products.where(is_active: params[:is_active]) if params[:is_active].present?
        products = products.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?

        render json: ProductSerializer.render(products), status: :ok
      end

      # GET /api/v1/products/:id
      def show
        render json: ProductSerializer.render(@product), status: :ok
      end

      # POST /api/v1/products
      def create
        product = Product.new(product_params)

        if product.save
          render json: ProductSerializer.render(product), status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/products/:id
      def update
        if @product.update(product_params)
          render json: ProductSerializer.render(@product), status: :ok
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/products/:id
      def destroy
        if @product.destroy
          head :no_content
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: [ "Product not found" ] }, status: :not_found
      end

      def product_params
        params.require(:product).permit(
          :sku, :name, :description, :product_type, :unit_of_measure,
          :cost, :price, :is_manufactured, :is_active
        )
      end
    end
  end
end
