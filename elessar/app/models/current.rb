# frozen_string_literal: true

# Thread-safe storage for current request context
class Current < ActiveSupport::CurrentAttributes
  attribute :organization, :user
end
