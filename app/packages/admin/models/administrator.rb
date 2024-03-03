class Administrator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :lockable, :trackable

  def self.ransackable_attributes(auth_object = nil)
    column_names
  end
end
