class CreateUserAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :selected_answer, null: false
      t.boolean :correct, default: false
      t.datetime :answered_at

      t.timestamps
    end
    
    add_index :user_answers, [:user_id, :question_id], unique: true
  end
end
