require 'rails_helper'

RSpec.describe OptOutLinksController, type: :controller do
  describe "GET #optout" do
    let(:manager) { FactoryBot.create(:employee) }
    let!(:recognition) { FactoryBot.create(:recognition,
                                            user: user,
                                            created_at: Time.parse('2018-10-01'),
                                            library_value: 'collab',
                                            description: 'perhaps something not nice',
                                            employee: employee) }   
    let(:employee) { FactoryBot.create(:employee) }
    let(:user) { FactoryBot.create(:user) }

    it 'should suppress the recognition with a valid key' do
      get :optout, params: { key: OptOutLink.first.key }
      expect(Recognition.find_by(id: recognition.id).suppressed).to be(true)
    end

    it 'should do nothing with an valid key' do
      get :optout, params: { key: 'utter-nonsense' }
      expect(recognition.suppressed).to be(false)
    end
  end
end
