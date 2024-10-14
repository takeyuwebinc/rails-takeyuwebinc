class WorkStyle < ApplicationRecord
  has_one_attached :image
  has_rich_text :description
  has_rich_text :content
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :title, presence: true

  def to_param
    slug
  end
end
