Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"  # custom controller for signup
  }

  # Optional custom sign_out path
  devise_scope :user do
    delete "sign_out", to: "devise/sessions#destroy"
  end

  # Profiles routes (only show/edit/update)
  resource :profile, only: [ :show, :edit, :update ]

  # Tasks routes
  resources :tasks do
    collection do
      get :calendar   # creates calendar_tasks_path
    end
  end

  # Todos routes (for admin vs normal users)
  resources :todos do
    collection do
      delete :destroy_all   # admin-only
    end
  end

  # Admin User Management routes
  resources :users, only: [ :index, :new, :create, :edit, :update, :destroy ] do
    member do
      patch :activate       # activate user account
      patch :deactivate     # deactivate user account
      patch :reset_password # reset user password
    end
  end

  # Memos routes (for users to write notes)
  resources :memos

  # Root page
  root "tasks#index"
end
