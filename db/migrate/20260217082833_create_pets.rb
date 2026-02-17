class CreatePets < ActiveRecord::Migration[8.1]
  def change
    create_table :pets do |t|
      t.string :name, null: false
      t.date :birthday
      t.date :adopted_at
      t.integer :gender
      t.boolean :active, default: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
