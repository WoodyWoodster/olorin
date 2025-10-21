# frozen_string_literal: true

class WarehouseSerializer < Blueprinter::Base
  identifier :id

  fields :code, :name, :is_active, :created_at, :updated_at

  association :addresses, blueprint: AddressSerializer
end
