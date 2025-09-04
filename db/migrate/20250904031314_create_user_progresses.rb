class CreateUserProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :user_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.datetime :completed_at
      t.integer :score
      t.integer :attempts, default: 1

      t.timestamps
    end
    
    add_index :user_progresses, [:user_id, :lesson_id], unique: true
  end
end
