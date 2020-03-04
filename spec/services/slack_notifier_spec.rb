require 'rails_helper'

RSpec.describe SlackNotifier, type: :service do
  describe '#call' do
    let!(:notifier) { described_class.new(employee_name: 'Triton, Jane',
                                          employee_rec_url: 'http://example.com/recognitions/1') }
    # Temporarily use SlackNotifier in test environment
    # This is set to false in config/environments/test
    # to prevent accidentally spamming the Slack channel during testing
    before(:each) do
      Rails.application.config.send_slack_notifications = true
    end

    after(:each) do
      Rails.application.config.send_slack_notifications = false
    end

    it 'prints first name then last when name is of form lastname, firstname' do
      expect(notifier.employee_name).to eq('Jane Triton')
    end

    context 'with SLACK_WEBHOOK_URL set' do
      before do
        ENV["SLACK_WEBHOOK_URL"] = "http://slack-api.com"
        # needed because we:
        # - don't want to actually call the Slack service
        # - call response.body in the logger
        response_double = instance_double('Net::HTTPResponse', body: :ok)
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(response_double)
      end

      after do
        ENV["SLACK_WEBHOOK_URL"] = "http://slack-api.com"
      end

      it 'calls notify_slack' do
        expect(notifier.call).to be_truthy
      end
    end

    context 'without SLACK_WEBHOOK_URL set' do
      before do
        allow(ENV).to receive(:[]).with("SLACK_WEBHOOK_URL").and_return(nil)
      end

      it 'returns and does not post a notification' do
        expect(notifier.call).to be(nil)
      end
    end
  end
end
