class CreateWorks < ActiveRecord::Migration[7.2]
  def change
    create_table :works, comment: "案件" do |t|
      t.string :slug, null: false, index: { unique: true }
      t.string :title, null: false, comment: "案件名"
      t.references :client, null: false, foreign_key: true, comment: "お客様"
      t.text :points, comment: "ここがポイント（改行区切り）"
      t.integer :position, null: false, default: 0, comment: "表示順（降順）"

      t.timestamps
    end
  end
end
