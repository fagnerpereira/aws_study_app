class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :question_type, null: false
      t.text :content, null: false
      t.string :correct_answer, null: false
      t.text :options
      t.text :explanation
      t.integer :experience_points, null: false, default: 10

      t.timestamps
    end
  end
end
