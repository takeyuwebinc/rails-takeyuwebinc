# frozen_string_literal: true

class ArticleBoxComponent < ViewComponent::Base
  FIT_IMAGE = %w[cover contain].freeze

  def initialize(image:, title:, outline: nil, url: nil, fit_image: nil)
    raise ArgumentError, "fit_image must be one of the following: " + FIT_IMAGE.join(", ") if fit_image.present? && !FIT_IMAGE.include?(fit_image)
    @image = image
    @title = title
    @outline = outline
    @url = url
    @fit_image = fit_image
  end
end
