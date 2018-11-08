# frozen_string_literal: true

# Recognition
class Recognition < ApplicationRecord
  belongs_to :user
  belongs_to :employee

  validates :library_value, :description, presence: true

  # A custom finder used for identifying records created between a given date range
  def self.created_between(start_date, end_date)
    where(created_at: start_date..end_date)
  end
end
