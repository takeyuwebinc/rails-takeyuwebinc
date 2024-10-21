ActiveAdmin.register Work do
  include Rails.application.routes.url_helpers

  index do
    selectable_column
    id_column
    column :slug
    column :title
    column :position
    column :created_at
    actions
  end

  filter :slug
  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :slug
      f.input :title
      f.input :description, as: :rich_text_area
      f.input :content, as: :rich_text_area
      f.input :image, as: :file
      f.input :points
      f.input :position
      f.input :client
    end
    f.actions
  end
  permit_params :slug, :title, :description, :content, :image, :position, :points, :client_id

  show do
    attributes_table do
      row :slug
      row :title
      row :description do |record|
        record.description.body
      end
      row :content do |record|
        record.content.body
      end
      row :image do |record|
        image_tag Rails.application.routes.url_helpers.rails_blob_path(record.image, only_path: true)
      end
      row :position
      row :client
    end
    active_admin_comments_for(resource)
  end

  controller do
    def find_resource
      scoped_collection.find_by!(slug: params[:id])
    end
  end
end
