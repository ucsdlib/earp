require 'rails_helper'

RSpec.describe StatisticsHelper, type: :helper do
  describe '#generate_csv' do
    let(:recognition1) { FactoryBot.build_stubbed(:recognition,
                                                 user: user,
                                                 description: 'in report',
                                                 employee: employee) }
    let(:recognition2) { FactoryBot.build_stubbed(:recognition,
                                                 user: user,
                                                 description: 'not in report',
                                                 employee: employee) }
    let(:employee) { FactoryBot.build_stubbed(:employee) }
    let(:user) { FactoryBot.build_stubbed(:user) }

    it 'generates a csv with a set of Recognition records' do
      RECORDS_AND_HEADER_ROW = 3
      expect(helper.generate_csv([recognition1,recognition2]).split(/\n/).size).to eq RECORDS_AND_HEADER_ROW
    end
  end
end
