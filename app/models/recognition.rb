# frozen_string_literal: true

require 'digest/bubblebabble'

# Recognition
class Recognition < ApplicationRecord
  after_create :generate_link

  belongs_to :user
  belongs_to :employee

  validates :library_value, :description, presence: true

  # A custom finder used for identifying records created between a given date range
  def self.created_between(start_date, end_date)
    where(created_at: start_date..end_date)
  end

  # Generate an OptOutLink for this Recognition
  def generate_link
    key = Digest::SHA1.bubblebabble(id.to_s + Time.zone.now.to_s)
    OptOutLink.new(key: key, recognition_id: id, expires: 6.months.from_now).save
  end
end
