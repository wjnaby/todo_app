class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [ :username ]

  # Associations
  has_many :tasks, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :memos, dependent: :destroy  # ✅ added association for memos
  has_one_attached :avatar

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true, inclusion: { in: %w[user admin] }

  # Ensure default role when creating a user
  after_initialize :set_default_role, if: :new_record?

  # Role helpers
  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  private

  def set_default_role
    self.role ||= "user"
  end
end
