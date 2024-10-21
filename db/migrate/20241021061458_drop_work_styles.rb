class DropWorkStyles < ActiveRecord::Migration[7.2]
  def change
    drop_table :work_styles, comment: "働き方" do |t|
      t.string :slug, null: false, index: { unique: true }
      t.string :title, null: false, comment: "見出し"
      t.integer :position, null: false, default: 0, comment: "表示順（降順）"

      t.timestamps
    end
  end
end
