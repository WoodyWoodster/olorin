# frozen_string_literal: true

class Warehouse < ApplicationRecord
  include BelongsToOrganization

  # Associations
  has_many :stock_levels, dependent: :destroy
  has_many :products, through: :stock_levels
  has_many :stock_movements, dependent: :restrict_with_error
  has_many :addresses, as: :addressable, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { scope: :organization_id, case_sensitive: false }

  # Scopes
  scope :active, -> { where(is_active: true) }

  # Callbacks
  before_validation :normalize_code

  def primary_address
    addresses.address_type_warehouse.first || addresses.first
  end

  private

  def normalize_code
    self.code = code.to_s.upcase.strip if code.present?
  end
end
