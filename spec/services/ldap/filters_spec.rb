require 'rails_helper'

RSpec.describe Ldap::Filters, type: :service do
  describe '.employees' do
    it 'returns an LDAP filter for all Library employees' do
      expect(described_class.employees.to_s).to eq('(&(&(&(EmployeeID=*)(ObjectCategory=person))(ObjectClass=user))(!(sAMAccountName=lib-*)))')
    end
  end

  describe '.hifive_admin' do
    it 'returns an LDAP filter to check admin membership' do
      fake_credentials = { group: 'memberof=CN=lib-test' }
      allow(Rails.application.credentials).to receive(:ldap).and_return(fake_credentials)
      expect(described_class.hifive_admin('drseuss').to_s).to eq('(&(&(CN=drseuss)(&(&(&(EmployeeID=*)(ObjectCategory=person))(ObjectClass=user))(!(sAMAccountName=lib-*))))(memberof=memberof=CN=lib-test))')
    end
  end
end
