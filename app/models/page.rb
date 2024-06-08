require "tmpdir"

class Page < ApplicationRecord
  validates :path, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title path created_at updated_at]
  end

  # pathを整形する
  # 先頭は / から始まる
  # 末尾にファイル名を含まない場合 index.html を追加する
  DIRECTORY_INDEX = "index.html"
  def self.normalize_path(path)
    parts = path.split("/").reject(&:empty?)
    if parts.empty?
      parts.push(DIRECTORY_INDEX)
    else
      parts.push("index.html") unless parts.last.match?(%r{\.[^\.+]})
    end
    "/" + parts.join("/")
  end

  def self.find_path!(path)
    find_by!(path: normalize_path(path))
  end

  def path=(new_path)
    super(self.class.normalize_path(new_path))
  end

  class PageRender < Redcarpet::Render::HTML
    # h1 〜 h6 タグを生成する
    def header(text, header_level)
      text_size = case header_level
      when 1
        "text-4xl"
      when 2
        "text-3xl"
      when 3
        "text-2xl"
      when 4
        "text-xl"
      when 5
        "text-lg"
      when 6
        "text-base"
      end
      %Q(<h#{header_level} class="#{text_size} font-bold mt-4 mb-2">#{text}</h#{header_level}>)
    end

    def postprocess(full_document)
      full_document = %Q(<div class="text-gray-900 dark:text-gray-100">#{full_document}</div>)
      tailwindcss_output = nil

      Dir.mktmpdir(nil, Rails.root.join("tmp", "pages")) do |tmp_dir|
        html_path = File.join(tmp_dir, "page.html")
        input_path = File.join(tmp_dir, "input.css")
        output_path = File.join(tmp_dir, "output.css")
        tailwind_config_path = File.join(tmp_dir, "tailwind.config.js")

        full_document = ActiveRecord::Base.connected_to(role: :reading, prevent_writes: true) do
          ApplicationController.renderer.render_to_string(inline: full_document, layout: false)
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
            ]
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

  def self.render_markdown(markdown)
    Redcarpet::Markdown.new(PageRender, autolink: true, tables: true).render(markdown)
  end

  def to_html
    markdown.present? ? self.class.render_markdown(markdown) : ""
  end
end
