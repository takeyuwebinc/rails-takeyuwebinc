require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  before do
    credentials = spy("credentials")
    allow(credentials).to receive(:dig).with(:mailer, :admin).and_return("admin@test.host")
    allow(Rails.application).to receive_messages(credentials: credentials)
  end

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

    context "with invalid signature" do
      it "returns http success" do
        invalid_params = {
          contact: {
            files: [ "invalid" ]
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

      it "sends an email" do
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
        expect(ContactMailer).to receive(:notify).with(an_instance_of(Contact)).and_call_original
        post "/contacts", params: valid_params
      end
    end

    # ハニーポットフィールドへの入力がある場合、成功を返すように見せかけるが、保存されないことを確認する
    context "with spam" do
      it "returns http success" do
        valid_params = {
          contact: {
            name: "John Doe",
            email: "john@test.host",
            phone: "1234567890",
            company: "Test, Inc.",
            message: "Hello, World!",
            files: [],
            check: "1"
          }
        }
        post "/contacts", params: valid_params
        expect(response).to have_http_status(:success)
        expect(Contact.count).to eq 0
      end
    end
  end
end
