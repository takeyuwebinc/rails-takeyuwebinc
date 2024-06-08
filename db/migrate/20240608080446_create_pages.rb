class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.string :title, null: false, default: ""
      t.text :markdown
      t.string :path, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
