class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements, comment: "お知らせ" do |t|
      t.text :title, null: false, comment: "見出し"

      t.timestamps
    end
  end
end
