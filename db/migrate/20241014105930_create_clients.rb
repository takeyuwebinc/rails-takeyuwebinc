class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients, comment: "お客様" do |t|
      t.string :slug, null: false, index: { unique: true }
      t.string :name, null: false, comment: "名前"
      t.string :kana, null: false, comment: "カナ"
      t.string :website, null: true, comment: "ウェブサイトURL"
      t.boolean :private, null: false, default: false, comment: "非公開"

      t.timestamps
    end
  end
end
