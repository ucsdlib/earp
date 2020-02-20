# Load the Rails application.
require_relative 'application'

# Allow default_url_options to reuse action_mailer defaults
# This is used in the Recognition#notify_slack method to allow access to using url_helpers such as recognition_url
# without having to specify an explicit host parameter
Hifive::Application.default_url_options = Hifive::Application.config.action_mailer.default_url_options

# Initialize the Rails application.
Rails.application.initialize!
