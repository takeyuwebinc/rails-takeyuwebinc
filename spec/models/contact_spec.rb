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

  describe '#is_spam?' do
    it 'returns true if the check field is filled in' do
      contact = Contact.new
      contact.check = '1'
      expect(contact.is_spam?).to be true
    end

    it 'returns false if the check field is not filled in' do
      contact = Contact.new
      contact.check = [ '', nil ].sample
      expect(contact.is_spam?).to be false
    end
  end
end
