# frozen_string_literal: true

require 'digest/bubblebabble'

# Recognition
class Recognition < ApplicationRecord
  after_create :generate_link

  belongs_to :user
  belongs_to :employee

  validates :library_value, :description, presence: true

  # Custom scopes
  scope :most_recent, -> { order('created_at DESC') }
  scope :public_recognitions, -> { where(suppressed: false).most_recent }
  scope :all_recognitions, -> { all.most_recent }
  scope :feed, -> { public_recognitions.first(15) }

  # A custom finder used for identifying records created between a given date range
  def self.created_between(start_date, end_date)
    where(created_at: start_date..end_date)
  end

  # Generate an OptOutLink for this Recognition
  def generate_link
    generate_key(id)
    RecognitionMailer.email(Recognition.find(id)).deliver_now
  end

  def generate_key(recognition_id)
    key = Digest::SHA1.bubblebabble(recognition_id.to_s + Time.zone.now.to_s)
    OptOutLink.new(key: key, recognition_id: recognition_id, expires: 6.months.from_now).save
    key
  end
end
