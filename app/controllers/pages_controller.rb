class PagesController < ApplicationController
  include EnableCacheControlPublic

  def index
    @announcements = Announcement.order(created_at: :desc).limit(5)
  end
end
