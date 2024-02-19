require 'rails_helper'

RSpec.describe "Announcements", type: :request do
  describe "GET /announcements/:id" do
    it "returns http success" do
      announcement = create(:announcement)
      get "/announcements/#{announcement.to_param}"
      expect(response).to have_http_status(:success)
    end
  end
end
