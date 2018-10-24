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

  describe '.cache_employee_photo' do
    let(:entry1) { Net::LDAP::Entry.new('CN=aemployee,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU') }
    before do
      entry1['cn'] = 'aemployee'
      entry1['displayName'] = ['Employee, A']
      entry1['givenName'] = ['A']
      entry1['sn'] = ['Employee']
      entry1['mail'] = ['aemployee@ucsd.edu']
      entry1['manager'] = ['boss1@ucsd.edu']
    end
    context 'without an ldap photo' do
      it 'should not write to photos directory' do
        expect(described_class.cache_employee_photo(entry1)).to be_nil
      end
    end

    context 'with an ldap photo' do
      after do
        system("rm -rf #{Rails.root}/app/assets/images/photos/aemployee.jpg")
      end
      it 'should write to photos directory' do
        entry1['Thumbnailphoto'] = '/9j/4AAQSkZJRgABAQEAAQABAAD//2gAIAQEAAD8AVN//2Q=='
        described_class.cache_employee_photo(entry1)
        expect(File.file?("#{Rails.root}/app/assets/images/photos/aemployee.jpg")).to be true
      end
    end

  end
end
