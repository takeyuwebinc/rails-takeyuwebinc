class PagesController < ApplicationController
  include EnableCacheControlPublic

  def index
    @page = Page.find_path!("")
    render :show
  end

  def show
    @page = Page.find_path!(params[:path])
    add_breadcrumb "home", "/"
    add_breadcrumb @page.title, @page.path
  end
end
