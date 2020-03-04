# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# The SlackNotifier service class provides a simple interface to send a Slack notification
# to a pre-configured Slack App channel
# It is expected that the Slack incoming webhook will be provided as an environment variables
class SlackNotifier
  include RecognitionsHelper
  attr_reader :employee_name, :employee_rec_url
  TEMPLATE = 'Woo-hoo! :tada: %s just received a High Five! :raised_hands: Check it out :point_right: %s'

  # Entrypoint for calling classes such as Recognition
  def self.call(*args)
    new(*args).call
  end

  # @param employee_name [String] The display name for the recognized employee
  # @param employee_rec_url [String] The full url to the Recognition
  def initialize(employee_name:, employee_rec_url:)
    @employee_name = pretty_name(employee_name)
    @employee_rec_url = employee_rec_url
  end

  # Primary instance method which will trigger a Slack notification
  # rubocop:disable Metrics/MethodLength
  def call
    return unless Rails.application.config.send_slack_notifications

    if slack_webhook_url.nil?
      Rails.logger.tagged('slack', 'configuration') do
        Rails.logger.info 'No SLACK_WEBHOOK_URL environment variable present'
      end
      return
    end

    Rails.logger.tagged('slack', 'notification') do
      Rails.logger.info "Notifying Slack Channel for: #{employee_name} with url #{employee_rec_url} "
    end
    notify_slack
  end
  # rubocop:enable Metrics/MethodLength

  private

  def notify_slack
    uri = URI.parse(slack_webhook_url)

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      request.body = payload
      response = http.request request # Net::HTTPResponse object
      Rails.logger.tagged('slack', 'notification') { Rails.logger.info "Slack Channel Response: #{response.body}" }
    end
  end

  def slack_webhook_url
    @slack_webhook_url ||= ENV['SLACK_WEBHOOK_URL']
  end

  def payload
    {
      text: format(TEMPLATE, employee_name, employee_rec_url)
    }.to_json
  end
end
