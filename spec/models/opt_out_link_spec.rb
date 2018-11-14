require 'rails_helper'

RSpec.describe OptOutLink, type: :model do
  describe '.audit_expired_links' do
    let!(:expired_link) { FactoryBot.create(:opt_out_link,
                                                 key: 'expired-key',
                                                 expires: Time.parse('2018-10-01')) }
    let!(:non_expired_link) { FactoryBot.create(:opt_out_link,
                                                 key: 'valid-key',
                                                 expires: Time.parse('2020-10-01')) }
    it 'finds expired links and deletes them' do
      travel_to Date.new(2018, 10, 02) do
        described_class.audit_expired_links
        expect(OptOutLink.count).to be(1)
        expect(OptOutLink.first.key).to eq('valid-key')
      end
    end
  end

  describe '#to_param' do
    let!(:expired_link) { FactoryBot.build_stubbed(:opt_out_link, key: 'valid-key')}
    it 'overrides to_param for custom route url with key' do
      expect(expired_link.to_param).to eq('valid-key')
    end
  end
end
