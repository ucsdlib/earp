require 'rails_helper'

RSpec.describe Ldap, type: :service do
  describe '.employees_filter' do
    it 'returns an LDAP filter for all Library employees' do
      expect(described_class.employees_filter.to_s).to eq('(&(&(&(EmployeeID=*)(ObjectCategory=person))(ObjectClass=user))(!(sAMAccountName=lib-*)))')
    end
  end
end
