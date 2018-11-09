# frozen_string_literal: true

# OptOutLinks for Recogntions
class OptOutLink < ApplicationRecord
  # Will find and remove any OptOutLinks that have expired
  def self.audit_expired_links
    where('DATE(expires) <= ?', Time.zone.today).delete_all
  end
end
