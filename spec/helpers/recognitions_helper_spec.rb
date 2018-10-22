require 'rails_helper'

RSpec.describe RecognitionsHelper, type: :helper do
  describe '#library_values' do
    specify { expect(helper.library_values).to eq(LIBRARY_VALUES) }
  end
end
