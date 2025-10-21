# frozen_string_literal: true

class DeploymentSerializer < Blueprinter::Base
  identifier :id

  fields :app_id, :commit_sha, :status, :build_logs, :deployed_at,
         :created_at, :updated_at
end
