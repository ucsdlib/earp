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

  describe '.needs_update?' do
    let(:entry) { Net::LDAP::Entry.new('CN=aemployee,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU') }
    before do
      entry['cn'] = 'aemployee'
      entry['displayName'] = ['Employee, A']
      entry['givenName'] = ['A']
      entry['sn'] = ['Employee']
      entry['mail'] = ['aemployee@ucsd.edu']
      entry['manager'] = ['boss1@ucsd.edu']
      entry['whenChanged'] = ['20181127172427.0Z']
    end

    it 'returns true with a new record' do
      e = Employee.new
      expect(described_class.needs_update?(e, entry.whenChanged.first)).to be true
    end

    it 'returns true with an outdated record' do
      e = FactoryBot.build_stubbed(:employee, updated_at: Time.parse('2018-11-01'))
      expect(described_class.needs_update?(e, entry.whenChanged.first)).to be true
    end

    it 'returns false with an up to date record' do
      e = FactoryBot.build_stubbed(:employee, updated_at: Time.parse('2018-11-30'))
      expect(described_class.needs_update?(e, entry.whenChanged.first)).to be false
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
      entry1['whenChanged'] = ['20181127172427.0Z']
    end

    it 'should handle updating Employee records', :aggregate_failures do
      expect(Employee.count).to be_zero
      described_class.populate_from_ldap(entry1)
      entry1['displayName'] = 'Batman'
      entry1['whenChanged'] = ['20181130172427.0Z'] # newer record simulation
      described_class.populate_from_ldap(entry1)
      expect(Employee.count).to be(1)
      expect(Employee.first.display_name).to eq('Batman')
    end
  end
end
