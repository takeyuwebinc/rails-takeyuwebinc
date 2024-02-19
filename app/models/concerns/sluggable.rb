module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :set_slug
  end

  def to_slug
    SecureRandom.uuid
  end

  def to_param
    self.slug
  end

  def set_slug
    if self.slug.blank?
      assign_attributes(self.class.slug_column => to_slug)
    end
  end

  class_methods do
    def slug_column
      :slug
    end

    def find_by_slug!(slug)
      find_by!(self.slug_column => slug)
    end
  end
end
