class CreateNews < ActiveRecord::Migration[7.0]
  def change
    create_table :news do |t|
      t.belongs_to :user, null: false, foreign_key: true # ユーザーを外部キーとして参照

      t.string :author_name, null: false #投稿者名
      t.string :title, null: false #タイトル
      t.text :content, null: false #コンテンツ
      t.integer :category_id, null: false #ジャンルID
      t.integer :prefecture_id, null: false #都道府県ID
      t.timestamps
    end
  end
end