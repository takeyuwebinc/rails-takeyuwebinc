Rails.application.reloader.to_prepare do
  class ActiveStorage::DiskController
    before_action only: [ :show ] do
      expires_in ActiveStorage.service_urls_expire_in, public: true
    end
  end

  class ActiveStorage::Blob
    validates :byte_size, numericality: { less_than: 10.megabytes }, if: :byte_size_changed?
    validates :content_type, allow_nil: true, inclusion: { in: %w[image/png image/jpg image/jpeg image/gif image/webp image/svg+xml application/x-zip-compressed application/pdf text/plain] }, if: :content_type_changed?

    def self.ransackable_attributes(auth_object = nil)
      [ "byte_size", "checksum", "content_type", "created_at", "filename", "id", "id_value", "key", "metadata", "service_name" ]
    end
  end
end

Rails.application.config.active_storage.content_types_to_serve_as_binary.delete("image/svg+xml")
Rails.application.config.active_storage.content_types_allowed_inline << "image/svg+xml"
