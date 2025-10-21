# frozen_string_literal: true

class EnvVar < ApplicationRecord
  # Associations
  belongs_to :app

  # Validations
  validates :key, presence: true,
            uniqueness: { scope: :app_id },
            format: { with: /\A[A-Z0-9_]+\z/, message: "only uppercase letters, numbers, and underscores" }

  # Callbacks
  before_validation :normalize_key

  private

  def normalize_key
    self.key = key.to_s.upcase.strip if key.present?
  end
end
