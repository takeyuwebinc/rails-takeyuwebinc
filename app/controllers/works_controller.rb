class WorksController < ApplicationController
  include EnableCacheControlPublic

  def index
    render plain: "TODO: works#index"
  end

  def show
    render plain: "TODO: works#show"
  end
end
