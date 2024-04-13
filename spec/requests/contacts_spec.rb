require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/contacts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /" do
    context "with invalid attributes" do
      it "returns http success" do
        invalid_params = {
          contact: {
            name: ""
          }
        }
        post "/contacts", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid attributes" do
      it "returns http success" do
        blob = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("Hello, World!"), filename: "hello.txt")
        valid_params = {
          contact: {
            name: "John Doe",
            email: "john@test.host",
            phone: "1234567890",
            company: "Test, Inc.",
            message: "Hello, World!",
            files: [ blob.signed_id ]
          }
        }
        post "/contacts", params: valid_params
        expect(response).to have_http_status(:success)
        expect(Contact.count).to eq 1
        contact = Contact.first
        expect(contact.name).to eq "John Doe"
        expect(contact.files).to be_attached
      end
    end
  end
end
