# frozen_string_literal: true

class Domain < ApplicationRecord
  # Associations
  belongs_to :app

  # Validations
  validates :hostname, presence: true,
            uniqueness: true,
            format: { with: /\A[a-z0-9\-\.]+\z/, message: "invalid format" }

  # Scopes
  scope :verified, -> { where.not(verified_at: nil) }
  scope :ssl_enabled, -> { where(ssl_enabled: true) }

  def verified?
    verified_at.present?
  end
end
