require 'rails_helper'

RSpec.describe Employee, type: :model do
  context 'invalid recognition' do
    let(:employee) { Employee.new }
    it "must have required attributes" do
      expect(employee).to be_invalid
    end
  end


  context 'valid recognition' do
    let(:employee) { FactoryBot.build_stubbed(:employee) }
    it "persists with required attributes" do
      expect(employee).to be_valid
    end
  end
end
