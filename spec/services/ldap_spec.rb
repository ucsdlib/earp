require 'rails_helper'

RSpec.describe Ldap, type: :service do
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
end
