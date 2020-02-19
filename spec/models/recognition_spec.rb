require 'rails_helper'

RSpec.describe Recognition, type: :model do
  let!(:manager) { FactoryBot.create(:employee) }

  context 'invalid recognition' do
    let(:recognition) { Recognition.new }
    it "must have required attributes" do
      expect(recognition).to be_invalid
    end
  end


  context 'valid recognition' do
    let(:recognition) { FactoryBot.build_stubbed(:recognition,
                                                 user: user,
                                                 employee: employee) }
    let(:employee) { FactoryBot.build_stubbed(:employee) }
    let(:user) { FactoryBot.build_stubbed(:user) }
    it "persists with required attributes" do
      expect(recognition).to be_valid
    end
  end

  describe '#generate_link' do
    let!(:recognition) { FactoryBot.create(:recognition,
                                                 user: user,
                                                 created_at: Time.parse('2018-10-01'),
                                                 description: 'in report',
                                                 employee: employee) }
    let(:employee) { FactoryBot.create(:employee) }
    let(:user) { FactoryBot.create(:user) }

    it 'generates an OptOutLink' do
      expect(OptOutLink.count).to be(1)
      expect(OptOutLink.first.recognition_id).to eq(recognition.id)
    end
  end

  describe '.created_between' do
    let!(:recognition1) { FactoryBot.create(:recognition,
                                                 user: user,
                                                 created_at: Time.parse('2018-10-01'),
                                                 description: 'in report',
                                                 employee: employee) }
    let!(:recognition2) { FactoryBot.create(:recognition,
                                                 user: user,
                                                 created_at: Time.parse('2017-10-01'),
                                                 description: 'not in report',
                                                 employee: employee) }
    let(:employee) { FactoryBot.create(:employee) }
    let(:user) { FactoryBot.create(:user) }

    it 'finds recognitions in a given date range' do
      expect(described_class.created_between('2018-01-01', '2018-12-31').map(&:description)).to eq(['in report'])
    end

    it 'finds recognitions using an inclusive end date' do
      recognition3 = FactoryBot.create(:recognition,
                                       user: user,
                                       created_at: Time.parse('2018-12-31 9:00'),
                                       description: 'inclusive end date',
                                       employee: employee)
      expect(described_class.created_between('2018-01-01', '2018-12-31').map(&:description)).to eq(['in report', 'inclusive end date'])
    end
  end

  describe '.feed' do
    let!(:suppressed_recognition) { FactoryBot.create(:recognition,
                                                      suppressed: true,
                                                      description: 'not in feed',
                                                      user: user,
                                                      employee: employee) }
    let!(:public_recognition) { FactoryBot.create(:recognition,
                                                  user: user,
                                                  description: 'in feed',
                                                  employee: employee) }
    let(:employee) { FactoryBot.create(:employee) }
    let(:user) { FactoryBot.create(:user) }

    it 'only includes non-suppressed/public records' do
      expect(described_class.feed.map(&:description)).to eq(['in feed'])
    end
  end

  describe '.all_recognitions' do
    let!(:suppressed_recognition) { FactoryBot.create(:recognition,
                                                      suppressed: true,
                                                      description: 'suppressed',
                                                      user: user,
                                                      employee: employee) }
    let!(:public_recognition) { FactoryBot.create(:recognition,
                                                  user: user,
                                                  description: 'public',
                                                  employee: employee) }
    let(:employee) { FactoryBot.create(:employee) }
    let(:user) { FactoryBot.create(:user) }

    it 'includes all records, including non-suppressed/public' do
      expect(described_class.all_recognitions.map(&:description)).to eq(['public', 'suppressed'])
    end
  end
end
