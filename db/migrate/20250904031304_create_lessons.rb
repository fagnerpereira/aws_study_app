class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.references :domain, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.integer :position, null: false

      t.timestamps
    end
    
    add_index :lessons, [:domain_id, :position], unique: true
  end
end
