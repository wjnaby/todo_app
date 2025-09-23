class AddDefaultRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :role, from: nil, to: "user"
    # optional: also set existing nil roles to "user"
    User.where(role: nil).update_all(role: "user")
  end
end
