class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  # Remove this line to allow tasks without due_date
  # validates :due_date, presence: true

  # optional: set default status
  after_initialize :set_default_status, if: :new_record?

  private
  def set_default_status
    self.status ||= "pending"
  end
end
