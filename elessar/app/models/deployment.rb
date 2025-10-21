# frozen_string_literal: true

class Deployment < ApplicationRecord
  # Associations
  belongs_to :app

  # Enums
  enum :status, {
    pending: "pending",
    building: "building",
    deployed: "deployed",
    failed: "failed",
    rolled_back: "rolled_back"
  }, prefix: true

  # Validations
  validates :commit_sha, presence: true
  validates :status, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc).limit(10) }
  scope :successful, -> { where(status: :deployed) }
  scope :by_status, ->(status) { where(status: status) }
end
