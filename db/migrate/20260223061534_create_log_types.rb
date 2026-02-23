class CreateLogTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :log_types do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
