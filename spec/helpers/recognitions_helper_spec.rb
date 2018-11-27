require 'rails_helper'

RSpec.describe RecognitionsHelper, type: :helper do
  describe '#Validate URL' do
    it 'Checks to see if URL exists' do
      invalid_url = "#{Rails.configuration.image_path}employee.jpg"
      expect(helper.url_exist?(invalid_url)).to equal false
    end
  end
end
