class Announcement < ApplicationRecord
  validates :title, presence: true
  has_rich_text :content
  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at updated_at]
  end
end
