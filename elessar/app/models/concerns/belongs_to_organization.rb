# frozen_string_literal: true

module BelongsToOrganization
  extend ActiveSupport::Concern

  included do
    belongs_to :organization

    validates :organization, presence: true

    # Automatically scope all queries to current organization
    default_scope { where(organization_id: Current.organization&.id) }

    # Callback to set organization from current context
    before_validation :set_organization, on: :create

    private

    def set_organization
      self.organization_id ||= Current.organization&.id
    end
  end

  class_methods do
    # Use this to bypass organization scoping (use carefully!)
    def unscoped_by_organization
      unscoped
    end
  end
end
