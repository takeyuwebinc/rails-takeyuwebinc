class AnnouncementsController < ApplicationController
  include EnableCacheControlPublic
  include ActiveStorage::SetCurrent

  add_breadcrumb "home", "/"

  def show
    @announcement = Announcement.find_by_slug!(params[:id])
    add_breadcrumb @announcement.title, @announcement
  end
end
