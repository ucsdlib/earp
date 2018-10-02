require 'rails_helper'

RSpec.describe "Recognitions", type: :request do
  describe "GET /recognitions" do
    it "works! (now write some real specs)" do
      get recognitions_path
      expect(response).to have_http_status(200)
    end
  end
end
