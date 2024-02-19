class Announcement < ApplicationRecord
  include Sluggable
  validates :title, presence: true
  has_rich_text :content
  has_one_attached :image do |attachable|
    attachable.variant :default, { resize_to_limit: [ 1024, 1024 ], convert: :webp, saver: { subsample_mode: "on", strip: true, interlace: true, quality: 80 } }
    attachable.variant :thumb, { resize_to_limit: [ 360, 360 ], convert: :webp, saver: { subsample_mode: "on", strip: true, interlace: true, quality: 80 } }
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at updated_at]
  end

  def to_slug
    title.to_s.parameterize.presence || super
  end
end
