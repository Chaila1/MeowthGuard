class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest
      t.integer :failed_attempts, default:0
      t.datetime :locked_at
      t.string :unlock_token

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
