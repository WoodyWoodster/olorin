# frozen_string_literal: true

class ProductSerializer < Blueprinter::Base
  identifier :id

  fields :sku, :name, :description, :product_type, :unit_of_measure,
         :cost, :price, :is_manufactured, :is_active,
         :created_at, :updated_at
end
