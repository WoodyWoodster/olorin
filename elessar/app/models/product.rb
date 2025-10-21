# frozen_string_literal: true

class Product < ApplicationRecord
  include BelongsToOrganization

  # Associations
  has_many :bill_of_materials, dependent: :restrict_with_error
  has_many :bill_of_material_items, foreign_key: :component_id, dependent: :restrict_with_error
  has_many :stock_levels, dependent: :destroy
  has_many :warehouses, through: :stock_levels

  # Enums
  enum :product_type, {
    raw_material: "raw_material",
    component: "component",
    finished_good: "finished_good",
    service: "service"
  }, prefix: true

  enum :unit_of_measure, {
    piece: "piece",
    kilogram: "kilogram",
    gram: "gram",
    liter: "liter",
    milliliter: "milliliter",
    meter: "meter",
    centimeter: "centimeter",
    box: "box",
    case: "case"
  }, prefix: true

  # Validations
  validates :sku, presence: true, uniqueness: { scope: :organization_id, case_sensitive: false }
  validates :name, presence: true
  validates :product_type, presence: true
  validates :unit_of_measure, presence: true
  validates :cost, :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :manufactured, -> { where(is_manufactured: true) }
  scope :by_type, ->(type) { where(product_type: type) }

  # Callbacks
  before_validation :normalize_sku

  private

  def normalize_sku
    self.sku = sku.to_s.upcase.strip if sku.present?
  end
end
