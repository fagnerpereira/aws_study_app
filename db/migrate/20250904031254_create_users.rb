class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.integer :experience_points, default: 0, null: false
      t.integer :level, default: 1, null: false
      t.integer :current_streak, default: 0, null: false
      t.date :last_activity_date

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
