# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/notify
  def notify
    contact = Contact.new(
      name: "John Doe",
      company: "会社名",
      email: "user@test.host",
      phone: "1234567890",
      message: "Hello, World!",
    )
    ContactMailer.notify(contact)
  end
end
