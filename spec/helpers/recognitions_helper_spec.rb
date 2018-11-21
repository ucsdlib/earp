require 'rails_helper'

RSpec.describe RecognitionsHelper, type: :helper do
  describe '#Validate URL' do
    it 'Checks to see if URL exists' do
      valid_url = "#{Rails.configuration.image_path}test.jpg"
      invalid_url = "#{Rails.configuration.image_path}employee.jpg"
      expect(helper.url_exist?(valid_url)).to equal true
      expect(helper.url_exist?(invalid_url)).to equal false
    end
  end
end
