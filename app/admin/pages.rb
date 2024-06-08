ActiveAdmin.register Page do
  permit_params :path, :title, :markdown

  index do
    selectable_column
    id_column
    column :path
    column :title
    column :created_at
    column :updated_at
    actions
  end

  filter :path
  filter :title
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :path
      row :title
      row :markdown do
        tag.pre(resource.markdown)
      end
      row :built_html do
        tag.div(class: "w-full pt-10 pb-20") do
          resource.to_html&.html_safe
        end
      end
    end
    active_admin_comments_for(resource)
  end

  form do |f|
    f.inputs do
      f.input :path, as: :string
      f.input :title, as: :string
      f.input :markdown, as: :text
    end
    f.actions
  end
end
