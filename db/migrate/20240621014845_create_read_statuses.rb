class CreateReadStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :read_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :news, null: false, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end
