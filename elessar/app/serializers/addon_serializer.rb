# frozen_string_literal: true

class AddonSerializer < Blueprinter::Base
  identifier :id

  fields :app_id, :addon_type, :name, :connection_string, :status, :config,
         :created_at, :updated_at
end
