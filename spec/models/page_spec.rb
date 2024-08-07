require 'rails_helper'

RSpec.describe Page, type: :model do
  describe '.normalize_path' do
    it do
      expect(Page.normalize_path("path/to/")).to eq("/path/to/")
      expect(Page.normalize_path("/path/to/")).to eq("/path/to/")
      expect(Page.normalize_path("/path/to")).to eq("/path/to/")
      expect(Page.normalize_path("/")).to eq("/")
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
      path = "path/to"
      normalized_path = "/path/to/"
      allow(Page).to receive(:normalize_path).with(path).and_return(normalized_path)
      page = Page.new(path: path)
      expect(page.path).to eq(normalized_path)
    end
  end

  describe '#to_html' do
    it do
      page = create(:page, path: "/", markdown: "# Hello")
      built_html = page.to_html
      expect(built_html).to include(%Q(<div class="w-full pt-10 pb-20 px-5 sm:px-10">))
      expect(built_html).to include(%Q(<div class="page text-gray-900 dark:text-gray-100"><h1 class="text-3xl font-bold mb-2 border-b-2 border-gray-300 dark:border-gray-700 pb-2">Hello</h1></div>))
    end

    it do
      announcement = create(:announcement)
      page = build(:page, markdown: "<div><%= Announcement.destroy_all %></div>")
      expect { page.to_html }.to raise_error(ActionView::Template::Error, /Write query attempted/)
    end

    it do
      page = create(:page, path: "/", markdown: "# Hello")
      built_html = page.to_html(layout: true)
      expect(built_html).to include(%Q(<script type="module">import "application"</script>))
      expect(built_html).to include(%Q(<h1 class="text-3xl font-bold mb-2 border-b-2 border-gray-300 dark:border-gray-700 pb-2">Hello</h1>))
    end
  end
end
