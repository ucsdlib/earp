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

  describe '.populate_from_ldap' do
    let(:entry1) { Net::LDAP::Entry.new('CN=aemployee,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU') }
    before do
      entry1['cn'] = 'aemployee'
      entry1['displayName'] = ['Employee, A']
      entry1['givenName'] = ['A']
      entry1['sn'] = ['Employee']
      entry1['mail'] = ['aemployee@ucsd.edu']
      entry1['manager'] = ['boss1@ucsd.edu']
    end

    it 'should handle updating Employee records', :aggregate_failures do
      expect(Employee.count).to be_zero
      described_class.populate_from_ldap(entry1)
      entry1['displayName'] = 'Batman'
      described_class.populate_from_ldap(entry1)
      expect(Employee.count).to be(1)
      expect(Employee.first.display_name).to eq('Batman')
    end
  end
end
