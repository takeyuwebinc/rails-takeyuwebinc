class PagesController < ApplicationController
  before_action :set_cache_control

  def index
    @announcements = Announcement.order(created_at: :desc).limit(5)
  end

  private

    def set_cache_control
      request.session_options[:skip] = true
      expires_in 1.hour, public: true
    end
end
