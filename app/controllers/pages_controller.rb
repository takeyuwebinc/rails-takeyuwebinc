class PagesController < ApplicationController
  include EnableCacheControlPublic

  def index
    @page = Page.find_path!("")
    render html: @page.to_html(layout: true).html_safe
  end

  def show
    @page = Page.find_path!(params[:path])
    add_breadcrumb "home", "/"
    add_breadcrumb @page.title, @page.path
    render html: @page.to_html(layout: true).html_safe
  end
end
