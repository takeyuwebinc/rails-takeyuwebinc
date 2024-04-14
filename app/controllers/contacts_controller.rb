class ContactsController < ApplicationController
  add_breadcrumb "home", :root_path
  add_breadcrumb "お問い合わせ", :new_contact_path

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.is_spam? || @contact.save
      render :create, status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:name, :company, :email, :phone, :message, :check, files: [])
    end
end
