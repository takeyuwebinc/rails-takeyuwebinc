class Contact < ApplicationRecord
  has_many_attached :files

  validates :name, presence: true
  validates :company, presence: true
  validates :phone, presence: true, format: { with: /\A\d{10,11}\z/ }
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :message, length: { minimum: 10 }

  # honeypot field
  attribute :check, :string

  def phone=(value)
    super(value.tr("０-９", "0-9").gsub(/[^0-9]/, ""))
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name company phone email message created_at]
  end

  def is_spam?
    check.present?
  end
end
