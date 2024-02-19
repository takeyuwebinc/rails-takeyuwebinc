class AddSlugToAnnouncements < ActiveRecord::Migration[7.1]
  def up
    add_column :announcements, :slug, :string
    Announcement.find_each(&:save)
    change_column_null :announcements, :slug, false
    add_index :announcements, :slug, unique: true
  end

  def down
    remove_index :announcements, :slug
    remove_column :announcements, :slug
  end
end
