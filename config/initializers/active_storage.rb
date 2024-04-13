Rails.application.reloader.to_prepare do
  class ActiveStorage::DiskController
    before_action only: [ :show ] do
      expires_in ActiveStorage.service_urls_expire_in, public: true
    end
  end

  class ActiveStorage::Blob
    def self.ransackable_attributes(auth_object = nil)
      [ "byte_size", "checksum", "content_type", "created_at", "filename", "id", "id_value", "key", "metadata", "service_name" ]
    end
  end
end
