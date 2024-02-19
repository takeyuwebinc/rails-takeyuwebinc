ActiveAdmin.register Announcement do
  permit_params :title, :content, :image

  index do
    selectable_column
    id_column
    column :title
    column :created_at
    actions
  end

  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title, as: :string
      f.input :content, as: :rich_text_area # ActionText用の ActiveAdmin::Inputs::RichTextAreaInput を作成して使う
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      # ActionText
      row :content do |announcement|
        # NOTE: テキスト中の添付ファイルを開くにはもう一工夫必要 参考 https://github.com/activeadmin/activeadmin/pull/7546/files#diff-80d075982c34689b741e5077979b62a49161a5f60ca820dc74cd94e03c012c2e
        announcement.content.body
      end
      # ActiveStorage
      row :image do |announcement|
        image_tag Rails.application.routes.url_helpers.rails_blob_path(announcement.image, only_path: true)
      end
    end
    active_admin_comments_for(resource)
  end

  controller do
    def find_resource
      scoped_collection.find_by_slug!(params[:id])
    end
  end
end
