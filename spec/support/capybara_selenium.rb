# frozen_string_literal: true
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

if ENV["CIRCLECI"] == true
  Capybara.javascript_driver = :selenium_chrome_headless
else
  Capybara.javascript_driver = :chrome_headless
end

Capybara.javascript_driver = :chrome_headless

Capybara.default_max_wait_time = 5

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, type: :system, js: true) do
  if ENV["CIRCLECI"] == true
    driven_by :selenium_chrome_headless
  else
    driven_by :chrome_headless
  end
  end
end
