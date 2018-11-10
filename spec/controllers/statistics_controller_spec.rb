require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  describe "GET index" do
    context 'with statistics results' do
      let!(:recognition_in_range) { FactoryBot.create(:recognition,
                                                  user: user,
                                                  created_at: Time.parse('2018-10-01'),
                                                  library_value: 'collab',
                                                  description: 'in report',
                                                  employee: employee) }
      let!(:recognition_outside_range) { FactoryBot.create(:recognition,
                                                  user: user,
                                                  created_at: Time.parse('2017-10-01'),
                                                  library_value: 'flexible',
                                                  description: 'not in report',
                                                  employee: employee) }
      let(:employee) { FactoryBot.create(:employee) }
      let(:user) { FactoryBot.create(:user) }
      let(:csv_string) { "Reconizee,Recognizer,Value,Anonymous,Opted-Out,Submitted\nMyString,Jane Triton,collab,false,false,2018-10-01 00:00:00 UTC\n" }
      let(:csv_options) { {:filename=>"highfive-stats-2018-10-01-2018-10-15.csv"} }

      before do
        set_current_user
        mock_valid_library_employee
        mock_valid_library_administrator
        expect(@controller).to receive(:send_data)
          .with(csv_string, csv_options) { @controller.render nothing: true }
      end

      it "streams the csv report back to the administrator" do
        get :index, params: { start_date: '2018-10-01', end_date: '2018-10-15' }
      end
    end
  end

  context 'without any results' do
    let!(:recognition_outside_range) { FactoryBot.create(:recognition,
                                                user: user,
                                                created_at: Time.parse('2018-10-01'),
                                                library_value: 'collab',
                                                description: 'in report',
                                                employee: employee) }
    let(:employee) { FactoryBot.create(:employee) }
    let(:user) { FactoryBot.create(:user) }

    before do
      set_current_user
      mock_valid_library_employee
      mock_valid_library_administrator
    end

    it 'should respond with a flash notification' do
      get :index, params: { start_date: '1999-10-01', end_date: '1999-10-15' }
      expect(flash[:notice]).to be_present
    end
  end
end
