class AddUserToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :user, foreign_key: true

    reversible do |dir|
      dir.up do
        # Assign all existing tasks to the first user
        user = User.first || User.create!(email: "default@example.com", password: "password")
        Task.update_all(user_id: user.id)
        change_column_null :tasks, :user_id, false
      end
    end
  end
end
