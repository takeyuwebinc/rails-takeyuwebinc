class ContactsController < ApplicationController
  add_breadcrumb "home", :root_path
  add_breadcrumb "お問い合わせ", :new_contact_path

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.is_spam? || @contact.save
      ContactMailer.notify(@contact).deliver_later if @contact.persisted?
      render :create, status: :created
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature => e
    @contact = Contact.new(contact_params.except(:files))
    @contact.errors.add(:files, e.message)
    render :new, status: :unprocessable_entity
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :company, :email, :phone, :message, :check, files: [])
    end
end
