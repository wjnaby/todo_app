class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_user, only: [ :edit, :update, :destroy, :activate, :deactivate, :reset_password ]

  # GET /users
  # Admin can view all users
  def index
    @users = User.all.order(:username)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)

    # Generate temporary password
    temp_password = Devise.friendly_token.first(8)
    @user.password = temp_password
    @user.password_confirmation = temp_password

    if @user.save
      redirect_to users_path, notice: "User created successfully. Temporary password: #{temp_password}"
    else
      render :new
    end
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User updated successfully."
    else
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete yourself."
    else
      @user.destroy
      redirect_to users_path, alert: "User deleted successfully."
    end
  end

  # PATCH /users/:id/activate
  def activate
    @user.update(active: true)
    redirect_to users_path, notice: "User activated successfully."
  end

  # PATCH /users/:id/deactivate
  def deactivate
    if @user == current_user
      redirect_to users_path, alert: "You cannot deactivate yourself."
    else
      @user.update(active: false)
      redirect_to users_path, notice: "User deactivated successfully."
    end
  end

  # PATCH /users/:id/reset_password
  def reset_password
    temp_password = Devise.friendly_token.first(8)
    @user.update(password: temp_password, password_confirmation: temp_password)
    redirect_to users_path, notice: "Password reset successfully. New password: #{temp_password}"
  end

  private

  # Set the user based on params[:id]
  def set_user
    @user = User.find(params[:id])
  end

  # Ensure only admins can access these actions
  def require_admin
    redirect_to root_path, alert: "Access denied!" unless current_user.admin?
  end

  # Permit only safe attributes
  def user_params
    params.require(:user).permit(:username, :email, :role)
  end
end
