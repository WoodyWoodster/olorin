# frozen_string_literal: true

class Contact < ApplicationRecord
  include BelongsToOrganization

  # Associations
  belongs_to :company, optional: true

  # Validations
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :has_name_or_company

  # Scopes
  scope :primary, -> { where(is_primary: true) }

  def full_name
    [ first_name, last_name ].compact.join(" ").presence || email
  end

  private

  def has_name_or_company
    if first_name.blank? && last_name.blank? && company_id.blank?
      errors.add(:base, "Must have at least a name or be associated with a company")
    end
  end
end
