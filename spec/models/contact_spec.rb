require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#phone=' do
    it 'removes non-digit characters' do
      contact = Contact.new
      contact.phone = '000-0000-0000'
      expect(contact.phone).to eq '00000000000'
    end

    it 'converts full-width numbers to half-width numbers' do
      contact = Contact.new
      contact.phone = '（０００）００００ー００００'
      expect(contact.phone).to eq '00000000000'
    end
  end
end
