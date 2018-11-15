require 'rails_helper'

RSpec.describe "Recognitions", type: :request do
  describe "GET /recognitions" do
    it "works! (now write some real specs)" do
      get recognitions_path
      expect(response).to redirect_to(signin_path)
    end
  end
end
