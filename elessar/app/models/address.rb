# frozen_string_literal: true

class Address < ApplicationRecord
  include BelongsToOrganization

  # Associations
  belongs_to :addressable, polymorphic: true

  # Enums
  enum :address_type, {
    billing: "billing",
    shipping: "shipping",
    warehouse: "warehouse",
    other: "other"
  }, prefix: true

  # Validations
  validates :address_type, presence: true
  validates :street, :city, :country, presence: true

  def full_address
    [
      street,
      street2,
      "#{city}, #{state} #{postal_code}".strip,
      country
    ].compact_blank.join("\n")
  end

  def single_line_address
    [
      street,
      street2,
      city,
      state,
      postal_code,
      country
    ].compact_blank.join(", ")
  end
end
