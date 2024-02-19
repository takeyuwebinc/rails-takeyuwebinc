class PagesController < ApplicationController
  before_action :set_cache_control

  def index
    @announcements = Announcement.order(created_at: :desc).limit(5)
  end
end
