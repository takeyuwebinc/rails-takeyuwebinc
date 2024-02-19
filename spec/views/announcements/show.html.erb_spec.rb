require 'rails_helper'

RSpec.describe "announcements/show.html.erb", type: :view do
  it "displays the announcement" do
    assign(:announcement, create(:announcement, title: "This is an announcement"))
    render
    expect(rendered).to match(/This is an announcement/)
  end
end
