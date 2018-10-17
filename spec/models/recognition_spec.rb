require 'rails_helper'

RSpec.describe Recognition, type: :model do
  context 'invalid recognition' do
    let(:recognition) { Recognition.new }
    it "must have required attributes" do
      expect(recognition).to be_invalid
    end
  end


  context 'valid recognition' do
    let(:recognition) { FactoryBot.build_stubbed(:recognition, user: user) }
    let(:user) { FactoryBot.build_stubbed(:user) }
    it "persists with required attributes" do
      expect(recognition).to be_valid
    end
  end
end
