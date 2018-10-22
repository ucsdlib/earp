# frozen_string_literal: true

# Employee - populated from LDAP bulk query
# Should never be edited locally
class Employee < ApplicationRecord
  has_many :recognitions, dependent: :destroy

  validates :uid, :email, :manager, :display_name, :name, presence: true
end
