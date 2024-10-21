class WorksController < ApplicationController
  include EnableCacheControlPublic

  def index
    @works = Work.eager_load(image_attachment: :blob).with_rich_text_content.order(position: :desc).order(:position)
  end

  def show
    @work = Work.find_by!(slug: params[:id])
  end
end
