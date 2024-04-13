class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts, comment: "問い合わせ" do |t|
      t.string :name, null: false, comment: "名前"
      t.string :company, null: false, comment: "会社名"
      t.string :email, null: false, comment: "メールアドレス"
      t.string :phone, null: false, comment: "電話番号"
      t.text :message, null: false, comment: "問い合わせ内容"

      t.timestamps
    end
  end
end
