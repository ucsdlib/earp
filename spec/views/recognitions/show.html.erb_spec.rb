require 'rails_helper'

RSpec.describe "recognitions/show", type: :view do
  before(:each) do
    @recognition = assign(:recognition, Recognition.create!(
      :recognizee => "Recognizee",
      :library_value => "Library Value",
      :description => "MyText",
      :anonymous => false,
      :recognizer => "Recognizer"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Recognizee/)
    expect(rendered).to match(/Library Value/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Recognizer/)
  end
end
