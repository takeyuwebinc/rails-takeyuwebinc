class ApplicationController < ActionController::Base
  append_view_path(Dir.glob(Rails.root.join("app", "packages", "*", "views")))

  private

    def set_cache_control
      request.session_options[:skip] = true
      expires_in 1.hour, public: true
    end
end
