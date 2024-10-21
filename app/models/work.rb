class Work < ApplicationRecord
  belongs_to :client
  has_one_attached :image do |attachable|
    attachable.variant :default, { resize_to_limit: [ 1024, 1024 ], convert: :webp, saver: { subsample_mode: "on", strip: true, interlace: true, quality: 80 } }
    attachable.variant :thumb, { resize_to_limit: [ 360, 360 ], convert: :webp, saver: { subsample_mode: "on", strip: true, interlace: true, quality: 80 } }
  end
  has_rich_text :description
  has_rich_text :content
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :title, presence: true
  validates :points, presence: true
  validates :position, presence: true

  def to_param
    slug
  end

  def point_list
    points.split(/\r?\n/)
  end
end
