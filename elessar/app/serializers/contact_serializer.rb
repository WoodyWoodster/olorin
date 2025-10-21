# frozen_string_literal: true

class ContactSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :phone, :mobile, :role, :is_primary,
         :created_at, :updated_at

  field :full_name
  field :company_id
end
