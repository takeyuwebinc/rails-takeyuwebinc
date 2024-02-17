require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      announcement = create(:announcement, :with_image)
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body).to include(announcement.title)
    end
  end
end
