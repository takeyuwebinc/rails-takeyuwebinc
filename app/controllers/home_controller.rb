class HomeController < ApplicationController
  include EnableCacheControlPublic

  def index
    @works = Work.eager_load(image_attachment: :blob).with_rich_text_content.order(position: :desc).limit(3)
    @work_styles = WorkStyle.all.slice(0, 3)
  end
end
