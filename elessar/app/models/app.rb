# frozen_string_literal: true

class App < ApplicationRecord
  include BelongsToOrganization

  # Associations
  has_many :deployments, dependent: :destroy
  has_many :addons, dependent: :destroy
  has_many :domains, dependent: :destroy
  has_many :env_vars, dependent: :destroy

  # Enums
  enum :status, {
    stopped: "stopped",
    building: "building",
    running: "running",
    failed: "failed"
  }, prefix: true

  # Validations
  validates :name, presence: true
  validates :subdomain, presence: true,
            uniqueness: { scope: :organization_id, case_sensitive: false },
            format: { with: /\A[a-z0-9\-]+\z/, message: "only lowercase letters, numbers, and hyphens" }
  validates :status, presence: true

  # Scopes
  scope :running, -> { where(status: :running) }
  scope :by_status, ->(status) { where(status: status) }

  # Callbacks
  before_validation :normalize_subdomain

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.strip if subdomain.present?
  end
end
