# frozen_string_literal: true

class Company < ApplicationRecord
  include BelongsToOrganization

  # Associations
  has_many :contacts, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :sales_orders, foreign_key: :customer_id, dependent: :restrict_with_error
  has_many :purchase_orders, foreign_key: :supplier_id, dependent: :restrict_with_error
  has_many :invoices, dependent: :restrict_with_error

  # Enums
  enum :company_type, {
    customer: "customer",
    supplier: "supplier",
    both: "both"
  }, prefix: true

  # Validations
  validates :name, presence: true
  validates :company_type, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :customers, -> { where(company_type: [ "customer", "both" ]) }
  scope :suppliers, -> { where(company_type: [ "supplier", "both" ]) }

  # Helper methods
  def customer?
    company_type.in?([ "customer", "both" ])
  end

  def supplier?
    company_type.in?([ "supplier", "both" ])
  end

  def primary_contact
    contacts.find_by(is_primary: true) || contacts.first
  end

  def billing_address
    addresses.find_by(address_type: "billing") || addresses.first
  end

  def shipping_address
    addresses.find_by(address_type: "shipping") || billing_address
  end
end
