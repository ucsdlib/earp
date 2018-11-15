require 'rails_helper'

# RecognitionsController
RSpec.describe RecognitionsController, type: :controller do
  describe "GET Recognitions RSS feed" do
    it "returns an RSS feed" do
      get :feed, :format => "rss"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/rss+xml")
    end
  end
end
