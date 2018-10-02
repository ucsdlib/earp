require 'rails_helper'

RSpec.describe "recognitions/index", type: :view do
  before(:each) do
    assign(:recognitions, [
      Recognition.create!(
        :recognizee => "Recognizee",
        :library_value => "Library Value",
        :description => "MyText",
        :anonymous => false,
        :recognizer => "Recognizer"
      ),
      Recognition.create!(
        :recognizee => "Recognizee",
        :library_value => "Library Value",
        :description => "MyText",
        :anonymous => false,
        :recognizer => "Recognizer"
      )
    ])
  end

  it "renders a list of recognitions" do
    render
    assert_select "tr>td", :text => "Recognizee".to_s, :count => 2
    assert_select "tr>td", :text => "Library Value".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Recognizer".to_s, :count => 2
  end
end
