# frozen_string_literal: true

require 'digest/bubblebabble'

# Recognition
class Recognition < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_create :generate_link
  after_create :notify_slack

  belongs_to :user
  belongs_to :employee

  validates :library_value, :description, presence: true

  # Custom scopes
  scope :most_recent, -> { order('created_at DESC') }
  scope :public_recognitions, -> { where(suppressed: false).most_recent }
  scope :all_recognitions, -> { all.most_recent }
  scope :feed, -> { public_recognitions.first(15) }

  # A custom finder used for identifying records created between a given date range
  # Note that the end date will be set to the end of the day, to allow for an inclusive search.
  # @param start_date [String] start date for query of form YYYY-MM-DD
  # @param end_date [String] end date for query of form YYYY-MM-DD
  def self.created_between(start_date, end_date)
    inclusive_end_date = Time.parse(end_date).end_of_day
    where(created_at: start_date..inclusive_end_date)
  end

  def generate_key(recognition_id)
    key = Digest::SHA1.bubblebabble(recognition_id.to_s + Time.zone.now.to_s)
    OptOutLink.new(key: key, recognition_id: recognition_id, expires: 6.months.from_now).save
    key
  end

  private

  # Generate an OptOutLink for this Recognition
  def generate_link
    logger.tagged('recognition') { logger.info "sending email for recognition #{id}" }
    generate_key(id)
    RecognitionMailer.email(Recognition.find(id)).deliver_now
  end

  def notify_slack
    SlackNotifier.call(employee_name: employee.display_name,
                       employee_rec_url: recognition_url(self))
  end
end
