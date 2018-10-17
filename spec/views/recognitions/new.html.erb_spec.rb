require 'rails_helper'

RSpec.describe "recognitions/new", type: :view do
  before(:each) do
    # assign(:recognition, Recognition.new(
    #   :recognizee => "MyString",
    #   :library_value => "MyString",
    #   :description => "MyText",
    #   :anonymous => false,
    #   :recognizer => "MyString"
    # ))
  end

  it "renders new recognition form" do
    pending "get capybara tests in place"
    render

    assert_select "form[action=?][method=?]", recognitions_path, "post" do

      # TODO: find better way to test this
      # assert_select "input[name=?]", "recognition[recognizee]"

      assert_select "input[name=?]", "recognition[library_value]"

      assert_select "textarea[name=?]", "recognition[description]"

      assert_select "input[name=?]", "recognition[anonymous]"

      # TODO: find better way to test this
      # assert_select "input[name=?]", "recognition[recognizer]"
    end
  end
end
