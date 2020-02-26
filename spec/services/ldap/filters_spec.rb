require 'rails_helper'

RSpec.describe Ldap::Filters, type: :service do
  describe '.employees' do
    it 'returns an LDAP filter for all Library employees' do
      expect(described_class.employees.to_s).to eq('(&(objectCategory=user)(memberOf:1.2.840.113556.1.4.1941:=CN=All Library Staff,OU=Groups,OU=University Library,DC=AD,DC=UCSD,DC=EDU))')
    end
  end

  describe '.hifive_admin' do
    it 'returns an LDAP filter to check admin membership' do
      expect(described_class.hifive_admin('drseuss').to_s).to eq('(&(&(SAMAccountName=drseuss)(&(objectCategory=user)(memberOf:1.2.840.113556.1.4.1941:=CN=All Library Staff,OU=Groups,OU=University Library,DC=AD,DC=UCSD,DC=EDU)))(memberof=memberof=CN=lib-test))')
    end
  end
end
