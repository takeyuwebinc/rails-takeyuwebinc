require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/jobs/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /rails_engineer" do
    it "returns http success" do
      get "/jobs/rails_engineer"
      expect(response).to have_http_status(:success)
    end
  end
end
