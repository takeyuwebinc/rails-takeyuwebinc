class ContactMailer < ApplicationMailer
  def notify(contact)
    @contact = contact

    contact.files.each do |file|
      attachments[file.filename.to_s] = file.download
    end
    mail subject: build_subject(contact), to: Rails.application.credentials.dig(:mailer, :admin), reply_to: contact.email
  end

  private

  def build_subject(contact)
    "#{contact.company}様からのお問い合わせ"
  end
end
