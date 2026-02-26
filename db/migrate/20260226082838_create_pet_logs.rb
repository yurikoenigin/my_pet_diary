class CreatePetLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :pet_logs do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.references :log_type, null: true, foreign_key: true

      t.float :weight
      t.datetime :occurred_at, null: false

      t.timestamps
    end
  end
end
