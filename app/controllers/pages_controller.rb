class PagesController < ApplicationController
  before_action :set_cache_control

  def index
  end

  private

    def set_cache_control
      request.session_options[:skip] = true
      expires_in 1.hour, public: true
    end
end
