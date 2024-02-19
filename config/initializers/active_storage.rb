Rails.application.reloader.to_prepare do
  class ActiveStorage::DiskController
    before_action only: [ :show ] do
      expires_in ActiveStorage.service_urls_expire_in, public: true
    end
  end
end
