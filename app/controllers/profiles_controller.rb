class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # If user wants to change password
    if params[:user][:password].present?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(user_params.except(:current_password))
          redirect_to profile_path, notice: "Profile and password updated successfully."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        @user.errors.add(:current_password, "is incorrect")
        render :edit, status: :unprocessable_entity
      end
    else
      # Update profile without password change
      if @user.update(user_params.except(:current_password, :password, :password_confirmation))
        redirect_to profile_path, notice: "Profile updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :username, :avatar, :preferences,
      :current_password, :password, :password_confirmation
    )
  end
end
