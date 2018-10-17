require 'rails_helper'

RSpec.describe RecognitionsHelper, type: :helper do
  describe '#library_values' do
    specify { expect(helper.library_values).to eq(LIBRARY_VALUES) }
  end

  describe '#employees' do
    it 'calls to Ldap for returning current employees' do
      mock_employee_query
      result = helper.employees
      expect(Ldap).to have_received(:employees)
    end
  end
end
