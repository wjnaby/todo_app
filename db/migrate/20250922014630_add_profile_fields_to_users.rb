class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # only add these if they are missing (prevents duplicate column errors)
    add_column :users, :avatar, :string unless column_exists?(:users, :avatar)
    add_column :users, :preferences, :text unless column_exists?(:users, :preferences)
  end
end
