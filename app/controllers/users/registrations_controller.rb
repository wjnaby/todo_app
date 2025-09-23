# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]

  protected

  # Permit only the fields you want users to fill in
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :email, :password, :password_confirmation ])
  end

  # Force role = "user" every time a new account is created
  def build_resource(hash = {})
    super
    self.resource.role = "user"
  end
end
