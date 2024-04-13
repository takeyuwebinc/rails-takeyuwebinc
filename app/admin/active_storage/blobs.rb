ActiveAdmin.register ActiveStorage::Blob do
  index do
    selectable_column
    id_column
    column :key
    column :filename
    column :content_type
    column :service_name
    column :byte_size
    column :created_at
    actions
  end

  filter :key
  filter :filename
  filter :content_type
  filter :service_name
  filter :created_at

  show do
    attributes_table do
      row :id
      row :service_name
      row :key
      row :filename
      row :content_type
      row :metadata
      row :byte_size
      row :created_at
      row :url do |blob|
        link_to blob.url do
          if blob.image?
            image_tag blob.representation(resize_to_limit: [ 100, 100 ]).processed.url
          else
            "download"
          end
        end
      end
    end
    active_admin_comments_for(resource)
  end

  controller do
    include ActiveStorage::SetCurrent
  end
end
