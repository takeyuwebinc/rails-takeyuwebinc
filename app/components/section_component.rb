# frozen_string_literal: true

class SectionComponent < ViewComponent::Base
  renders_one :outline
  renders_one :more

  def initialize(id:, title: "", title_en: "")
    @id = id
    @title = title
    @title_en = title_en
  end
end
