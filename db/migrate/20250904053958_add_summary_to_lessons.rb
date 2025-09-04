class AddSummaryToLessons < ActiveRecord::Migration[8.0]
  def change
    add_column :lessons, :summary, :text
  end
end
