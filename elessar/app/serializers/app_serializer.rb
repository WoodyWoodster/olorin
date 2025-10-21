# frozen_string_literal: true

class AppSerializer < Blueprinter::Base
  identifier :id

  fields :name, :subdomain, :git_url, :status, :description,
         :created_at, :updated_at
end
