# frozen_string_literal: true

class EnvVarSerializer < Blueprinter::Base
  identifier :id

  fields :app_id, :key, :value,
         :created_at, :updated_at
end
