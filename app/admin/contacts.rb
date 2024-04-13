ActiveAdmin.register Contact do
  include Rails.application.routes.url_helpers

  index do
    selectable_column
    id_column
    column :name
    column :company
    column :email
    column :phone
    column :created_at
    actions
  end

  filter :name
  filter :company
  filter :email
  filter :phone
  filter :message
  filter :created_at

  show do
    attributes_table do
      row :name
      row :company
      row :email
      row :phone
      row :message do |contact|
        simple_format(contact.message)
      end
      row :files do |contact|
        contact.files.each.map do |file|
          link_to "#{file.filename} (#{file.blob.byte_size / 1024}KB)", rails_blob_path(file, disposition: "attachment", only_path: true)
        end
      end
    end
    active_admin_comments_for(resource)
  end
end
