require "rails_helper"

RSpec.describe ContactMailer, type: :mailer do
  describe "reqceived" do
    let(:mail) { ContactMailer.notify(contact) }
    let(:contact) do
      create(
        :contact,
        company: "会社名",
        email: "user@test.host",
        message: "Hello, World!",
      )
    end

    before do
      credentials = spy("credentials")
      allow(credentials).to receive(:dig).with(:mailer, :admin).and_return("admin@test.host")
      allow(Rails.application).to receive_messages(credentials: credentials)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("会社名様からのお問い合わせ")
      expect(mail.to).to eq([ "admin@test.host" ])
      expect(mail.from).to eq([ "no-reply@mail.takeyuweb.co.jp" ])
      expect(mail.reply_to).to eq([ "user@test.host" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello, World!")
    end

    context 'with files' do
      before do
        blob = ActiveStorage::Blob.create_and_upload!(io: StringIO.new("Hello, World!"), filename: "hello.txt")
        contact.files.attach(blob)
      end

      it "attached files" do
        expect(mail.attachments.count).to eq(1)
        attachment = mail.attachments.first
        expect(attachment.filename).to eq("hello.txt")
        expect(attachment.body.to_s).to eq("Hello, World!")
      end
    end
  end
end
