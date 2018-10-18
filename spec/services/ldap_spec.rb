require 'rails_helper'

RSpec.describe Ldap, type: :service do
  describe '.earp_group' do
    before do
      fake_credentials = { group: 'memberof=CN=lib-test' }
      allow(Rails.application.credentials).to receive(:ldap).and_return(fake_credentials)
      entry1 = Net::LDAP::Entry.new('CN=drseuss,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU')
      entry1['samaccountname'] = 'drseuss'
      entry2 = Net::LDAP::Entry.new('CN=nonadmin,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU')
      entry2['samaccountname'] = ''
      mock_ldap_validation
      allow(mock_ldap_connection).to receive(:search).and_yield(entry1).and_yield(entry2)
    end

    it 'returns an empty string with no match' do
      expect(described_class.earp_group('nonadmin')).to eq('')
    end

    it 'returns the cn for the given user with a match' do
      expect(described_class.earp_group('drseuss')).to eq('')
    end
  end

  describe '.employees' do
    before do
      entry1 = Net::LDAP::Entry.new('CN=aemployee,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU')
      entry1['cn'] = 'aemployee'
      entry1['displayName'] = ["Employee, A"]
      entry2 = Net::LDAP::Entry.new('CN=zbestemployee,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU')
      entry2['cn'] = 'zbestemployee'
      entry2['displayName'] = ["Zbestemployee, The"]
      mock_ldap_validation
      allow(mock_ldap_connection).to receive(:search).and_yield(entry1).and_yield(entry2)
    end

    it 'returns all entries' do
      expect(described_class.employees.size).to eq(2)
    end
    it 'returns a sorted list' do
      expect(described_class.employees.first[0]).to eq('Employee, A')
      expect(described_class.employees.last[0]).to eq('Zbestemployee, The')
    end
  end

  describe '.manager' do
    before do
      entry = Net::LDAP::Entry.new('CN=,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU')
      entry['manager'] = 'CN=drseuss,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU'
      mock_ldap_validation
      allow(mock_ldap_connection).to receive(:search).and_yield(entry)
      allow(Ldap).to receive(:manager_details).and_return({ first_name: 'Dr.',
                                                            last_name: 'Seuss',
                                                            email: 'drseuss@ucsd.edu' })
    end

    it 'return a hash of manager information for a given employee' do
      expect(described_class.manager('employee')).to eq({:email=>"drseuss@ucsd.edu",
                                                         :first_name=>"Dr.",
                                                         :last_name=>"Seuss"})
    end
  end

  describe '.manager_details' do
    let(:dn) { 'CN=drseuss,OU=Users,OU=University Library,DC=AD,DC=UCSD,DC=EDU' }
    before do
      entry = Net::LDAP::Entry.new(dn)
      entry['sn'] = 'Seuss'
      entry['givenname'] = 'Dr.'
      entry['mail'] = 'drseuss@ucsd.edu'
      mock_ldap_validation
      allow(mock_ldap_connection).to receive(:search).and_yield(entry)
    end

    it 'returns a hash of manager information for a given employee' do
      expect(described_class.manager_details(dn)).to eq({:email=>"drseuss@ucsd.edu",
                                                         :first_name=>"Dr.",
                                                         :last_name=>"Seuss"})
    end
  end

  describe '.employees_filter' do
    it 'returns an LDAP filter for all Library employees' do
      expect(described_class.employees_filter.to_s).to eq('(&(&(&(EmployeeID=*)(ObjectCategory=person))(ObjectClass=user))(!(sAMAccountName=lib-*)))')
    end
  end

  describe '.earp_filter' do
    it 'returns an LDAP filter to check admin membership' do
      fake_credentials = { group: 'memberof=CN=lib-test' }
      allow(Rails.application.credentials).to receive(:ldap).and_return(fake_credentials)
      expect(described_class.earp_filter('drseuss').to_s).to eq('(&(&(sAMAccountName=drseuss)(objectcategory=user))(memberof=memberof=CN=lib-test))')
    end
  end

  describe '.manager_filter' do
    it 'returns an LDAP filter to find the manager of an given employee' do
      expect(described_class.manager_filter('drseuss').to_s).to eq('(&(CN=drseuss)(objectcategory=user))')
    end
  end

  describe '.validate_ldap_response' do
    it 'raises an error with a non-zero exit code' do
      operation_result = OpenStruct.new(:code => 1, :message => 'Something terrible happened')
      allow(mock_ldap_connection).to receive(:get_operation_result).and_return(operation_result)
      expect{ described_class.validate_ldap_response }.to raise_error(RuntimeError).
        with_message("Response Code: 1\nMessage: Something terrible happened\n")
    end

    it 'returns nil with a zero exit code' do
      operation_result = OpenStruct.new(:code => 0, :message => 'LDAP here, all is well')
      allow(mock_ldap_connection).to receive(:get_operation_result).and_return(operation_result)
      expect{ described_class.validate_ldap_response }.not_to raise_error
    end
  end
end
