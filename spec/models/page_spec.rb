require 'rails_helper'

RSpec.describe Page, type: :model do
  describe '.normalize_path' do
    it do
      expect(Page.normalize_path("path/to/file.txt")).to eq("/path/to/file.txt")
      expect(Page.normalize_path("/path/to/")).to eq("/path/to/index.html")
      expect(Page.normalize_path("/path/to")).to eq("/path/to/index.html")
      expect(Page.normalize_path("/")).to eq("/index.html")
    end
  end

  describe '.find_path!' do
    it do
      page = create(:page)
      expect(Page.find_path!(page.path)).to eq(page)
    end
  end

  describe '#path=' do
    it do
      normalized_path = "/path/to/file.txt"
      allow(Page).to receive(:normalize_path).with("path/to/file.txt").and_return(normalized_path)
      page = Page.new(path: "path/to/file.txt")
      expect(page.path).to eq(normalized_path)
    end
  end

  describe '#to_html' do
    it do
      page = create(:page, path: "/index.html", markdown: "# Hello")
      built_html = page.to_html
      expect(built_html).to include(%Q(<div class="text-gray-900 dark:text-gray-100">))
      expect(built_html).to include(%Q(<h1 class="text-4xl font-bold mt-4 mb-2">Hello</h1>))
      expect(built_html).to include(%Q(! tailwindcss))
    end

    it do
      announcement = create(:announcement)
      page = build(:page, markdown: "<div><%= Announcement.destroy_all %></div>")
      expect { page.to_html }.to raise_error(ActionView::Template::Error, /Write query attempted/)
    end

    it do
      page = create(:page, path: "/index.html", markdown: "# Hello")
      built_html = page.to_html(layout: true)
      expect(built_html).to include(%Q(<script type="module">import "application"</script>))
      expect(built_html).to include(%Q(<h1 class="text-4xl font-bold mt-4 mb-2">Hello</h1>))
    end
  end
end
