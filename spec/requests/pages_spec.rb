require 'rails_helper'

RSpec.describe "GET /*path", type: :request do
  it "returns http success" do
    page = create(:page, path: "/company")
    get "/company"
    expect(response).to have_http_status(:success)
    expect(response.body).to include(page.title)
  end
end
