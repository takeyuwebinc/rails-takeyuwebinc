class AnnouncementsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_cache_control
  add_breadcrumb "home", :root_path

  def show
    @announcement = Announcement.find_by_slug!(params[:id])
    add_breadcrumb @announcement.title, @announcement
  end
end
