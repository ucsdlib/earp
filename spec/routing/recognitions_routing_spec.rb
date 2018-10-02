require "rails_helper"

RSpec.describe RecognitionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/recognitions").to route_to("recognitions#index")
    end

    it "routes to #new" do
      expect(:get => "/recognitions/new").to route_to("recognitions#new")
    end

    it "routes to #show" do
      expect(:get => "/recognitions/1").to route_to("recognitions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/recognitions/1/edit").to route_to("recognitions#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/recognitions").to route_to("recognitions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/recognitions/1").to route_to("recognitions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/recognitions/1").to route_to("recognitions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/recognitions/1").to route_to("recognitions#destroy", :id => "1")
    end
  end
end
