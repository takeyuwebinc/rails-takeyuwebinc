ActiveAdmin.register Client do
  index do
    selectable_column
    id_column
    column :slug
    column :name
    column :created_at
    actions
  end

  filter :slug
  filter :name
  filter :kana
  filter :private
  filter :created_at

  form do |f|
    f.inputs do
      f.input :slug
      f.input :name
      f.input :kana
      f.input :website
      f.input :private
    end
    f.actions
  end
  permit_params :slug, :name, :kana, :website, :private

  show do
    attributes_table do
      row :slug
      row :name
      row :kana
      row :website
      row :private
    end
    active_admin_comments_for(resource)
  end
end
