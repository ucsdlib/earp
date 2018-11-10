# frozen_string_literal: true

# OptOutLinks for Recogntions
class OptOutLink < ApplicationRecord
  # overrides AR::Base method
  # allows ActionPack to contruct optoutlinks using the key
  # optout_example = OptOutLink.first
  # optout_path(optout_example) => "/optout/the-digest-key"
  # optout_url(optout_example) => "http://www.example.com/optout/a-test-for-path"
  def to_param
    key
  end

  # Will find and remove any OptOutLinks that have expired
  def self.audit_expired_links
    where('DATE(expires) <= ?', Time.zone.today).delete_all
  end
end
