class Todo < ApplicationRecord
  # Optional: add associations if you have users
  belongs_to :user, optional: true
end
