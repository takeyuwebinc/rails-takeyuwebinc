require "tmpdir"

class Page < ApplicationRecord
  validates :path, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title path created_at updated_at]
  end

  # pathを整形する
  # 先頭は / から始まり、末尾は / で終わる
  def self.normalize_path(path)
    "/" + path.split("/").reject(&:empty?).push("").join("/")
  end

  def self.find_path!(path)
    find_by!(path: normalize_path(path))
  end

  def path=(new_path)
    super(self.class.normalize_path(new_path))
  end

  class PageRender < Redcarpet::Render::HTML
    def initialize(options = {})
      @layout = !!options.delete(:layout)
      super(options)
    end

    # h1 〜 h6 タグを生成する
    def header(text, header_level)
      header_class = case header_level
      when 1
        "text-3xl font-bold mb-2 border-b-2 border-gray-300 dark:border-gray-700 pb-2"
      when 2
        "text-2xl font-bold mt-9 mb-2 border-b border-gray-300 dark:border-gray-700 pb-2"
      when 3
        "text-xl font-bold mt-9 mb-2"
      when 4
        "text-lg font-bold mt-9 mb-2"
      when 5
        "text-base font-bold mt-9 mb-2"
      when 6
        "text-base font-bold"
      end
      %Q(<h#{header_level} class="#{header_class}">#{text}</h#{header_level}>)
    end

    def postprocess(full_document)
      full_document = %Q(<div class="page">#{full_document}</div>)
      tailwindcss_output = nil

      Dir.mktmpdir(nil, Rails.root.join("tmp", "pages")) do |tmp_dir|
        html_path = File.join(tmp_dir, "page.html")
        input_path = File.join(tmp_dir, "input.css")
        output_path = File.join(tmp_dir, "output.css")
        tailwind_config_path = File.join(tmp_dir, "tailwind.config.js")

        full_document = ActiveRecord::Base.connected_to(role: :reading, prevent_writes: true) do
          ApplicationController.renderer.render_to_string(inline: full_document, layout: @layout)
        end
        File.write(html_path, full_document)
        File.write(input_path, <<~CSS)
          @tailwind base;
          @tailwind components;
          @tailwind utilities;

          @layer base {
            :root { font-family: "Noto Sans JP", sans-serif; }
          }

          @layer base {
            a { @apply underline hover:no-underline hover:opacity-75 }
            .page p { line-height: 1.75; }
          }
        CSS
        File.write(tailwind_config_path, <<~JS)
          const defaultTheme = require('tailwindcss/defaultTheme')
          module.exports = {
            content: [
              '#{tmp_dir}/page.html'
            ],
            theme: {
              extend: {
                fontFamily: {
                  sans: ['Inter var', ...defaultTheme.fontFamily.sans],
                },
                colors: {
                  'corporate-50': '#0ab360',
                  'corporate-100': '#b0ffcd',
                  'corporate-200': '#80ffb3',
                  'corporate-300': '#50ff9b',
                  'corporate-400': '#28ff88',
                  'corporate-500': '#18e676',
                  'corporate-600': '#0ab360',
                  'corporate-700': '#008048',
                  'corporate-800': '#004d25',
                  'corporate-900': '#001b07',
                  'ruby': '#cc342d',
                },
              },
            },
            plugins: [
              require('@tailwindcss/forms'),
              require('@tailwindcss/aspect-ratio'),
              require('@tailwindcss/typography'),
              require('@tailwindcss/container-queries'),
            ],
            corePlugins: {
              preflight: false,
            }
          }
        JS
        system("npx tailwindcss -c #{tailwind_config_path} -i #{input_path} -o #{output_path} 2> /dev/null 1> /dev/null", { chdir: Rails.root })
        tailwindcss_output = File.read(output_path)
      end

      <<~HTML
        <style>
          #{tailwindcss_output}
        </style>
        <div>
          #{full_document}
        </div>
      HTML
    end
  end

  def self.render_markdown(markdown, layout: false)
    Redcarpet::Markdown.new(PageRender.new(layout: layout), autolink: true, tables: true).render(markdown)
  end

  def to_html(layout: false)
    markdown.present? ? self.class.render_markdown(markdown, layout: layout) : ""
  end
end
