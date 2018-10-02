require 'rails_helper'

RSpec.describe "recognitions/edit", type: :view do
  before(:each) do
    @recognition = assign(:recognition, Recognition.create!(
      :recognizee => "MyString",
      :library_value => "MyString",
      :description => "MyText",
      :anonymous => false,
      :recognizer => "MyString"
    ))
  end

  it "renders the edit recognition form" do
    render

    assert_select "form[action=?][method=?]", recognition_path(@recognition), "post" do

      assert_select "input[name=?]", "recognition[recognizee]"

      assert_select "input[name=?]", "recognition[library_value]"

      assert_select "textarea[name=?]", "recognition[description]"

      assert_select "input[name=?]", "recognition[anonymous]"

      assert_select "input[name=?]", "recognition[recognizer]"
    end
  end
end
