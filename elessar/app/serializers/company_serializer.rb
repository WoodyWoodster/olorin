# frozen_string_literal: true

class CompanySerializer < Blueprinter::Base
  identifier :id

  fields :name, :company_type, :tax_id, :website, :phone, :email, :is_active,
         :created_at, :updated_at

  association :contacts, blueprint: ContactSerializer
  association :addresses, blueprint: AddressSerializer

  view :simple do
    fields :id, :name, :company_type, :email
  end
end
