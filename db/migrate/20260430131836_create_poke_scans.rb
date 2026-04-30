class CreatePokeScans < ActiveRecord::Migration[8.0]
  def change
    create_table :poke_scans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cardName
      t.string :prediction
      t.float :confidenceScore
      t.text :reasoning

      t.timestamps
    end
  end
end
