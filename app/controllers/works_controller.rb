class WorksController < ApplicationController
  include EnableCacheControlPublic

  def index
    @works = Work.order(:position)
  end

  def show
    @work = Work.find_by!(slug: params[:id])
  end
end
