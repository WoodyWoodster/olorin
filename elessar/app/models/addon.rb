# frozen_string_literal: true

class Addon < ApplicationRecord
  # Associations
  belongs_to :app

  # Enums
  enum :addon_type, {
    postgres: "postgres",
    mysql: "mysql",
    redis: "redis",
    mongodb: "mongodb"
  }, prefix: true

  enum :status, {
    provisioning: "provisioning",
    available: "available",
    failed: "failed",
    deprovisioning: "deprovisioning"
  }, prefix: true

  # Validations
  validates :addon_type, presence: true
  validates :name, presence: true
  validates :status, presence: true

  # Scopes
  scope :available, -> { where(status: :available) }
  scope :by_type, ->(type) { where(addon_type: type) }
end
