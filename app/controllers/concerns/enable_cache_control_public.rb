module EnableCacheControlPublic
  extend ActiveSupport::Concern

  included do
    before_action -> do
      request.session.clear
      request.session_options[:skip] = true
      expires_in 1.hour, public: true
    end
  end
end
