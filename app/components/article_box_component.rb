# frozen_string_literal: true

class ArticleBoxComponent < ViewComponent::Base
  def initialize(image:, title:, outline:, url: nil)
    @image = image
    @title = title
    @outline = outline
    @url = url
  end
end
