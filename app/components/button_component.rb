# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  VARIANTS = %i[primary secondary].freeze

  def initialize(tag: "a", variant: :primary, **params)
    raise ArgumentError, "Invalid variant" unless VARIANTS.include?(variant)
    @tag = tag
    @variant = variant
    @params = params
  end
end
