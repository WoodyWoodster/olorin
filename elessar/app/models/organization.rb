class Organization < ApplicationRecord
  # Associations
  has_many :users, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: { case_sensitive: false }
  validates :subdomain, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }

  # Scopes
  scope :active, -> { where(is_active: true) }

  # Callbacks
  before_validation :normalize_subdomain

  private

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.strip if subdomain.present?
  end
end
