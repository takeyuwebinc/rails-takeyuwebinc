require 'rails_helper'

RSpec.describe "Companies", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/company"
      expect(response).to have_http_status(:success)
    end
  end
end
