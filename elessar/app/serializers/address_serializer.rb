# frozen_string_literal: true

class AddressSerializer < Blueprinter::Base
  identifier :id

  fields :address_type, :street, :street2, :city, :state, :postal_code, :country,
         :created_at, :updated_at

  field :full_address
  field :single_line_address
end
