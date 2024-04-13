# 参考 https://github.com/activeadmin/activeadmin/pull/7546/files#diff-5e21824c25f3939be0166b33988b18303ee4f456251486869a6b7266249d299c
module ActiveAdmin
  module Inputs
    class RichTextAreaInput < ::Formtastic::Inputs::StringInput
      def to_html
        input_wrapping do
          editor_tag = builder.rich_text_area(method, input_html_options)
          editor = template.content_tag("div", editor_tag, class: "trix-editor-wrapper")
          label_html + editor
        end
      end
    end
  end
end
