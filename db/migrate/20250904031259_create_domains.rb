class CreateDomains < ActiveRecord::Migration[8.0]
  def change
    create_table :domains do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :position, null: false
      t.decimal :weight, null: false, precision: 5, scale: 4

      t.timestamps
    end
    
    add_index :domains, :position, unique: true
    add_index :domains, :name, unique: true
  end
end
