# frozen_string_literal: true

class DomainSerializer < Blueprinter::Base
  identifier :id

  fields :app_id, :hostname, :ssl_enabled, :verified_at,
         :created_at, :updated_at
end
