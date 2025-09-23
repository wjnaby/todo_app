class AddCategoryToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :category, :string
  end
end
