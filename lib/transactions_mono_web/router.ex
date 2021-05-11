defmodule TransactionsMonoWeb.Router do
  use TransactionsMonoWeb, :router
  import Phoenix.LiveView.Router

  import TransactionsMonoWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_live_flash)
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(:put_layout, {TransactionsMonoWeb.LayoutView, "app.html"})
    plug :put_root_layout, {TransactionsMonoWeb.LayoutView, :root}
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :user do
    plug(:require_authenticated_user)
  end

  scope "/", TransactionsMonoWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/dashboard", TransactionsMonoWeb do
    pipe_through [:browser, :user]

    get "/balance", BalanceController, :index
  end


  ## Authentication routes

  scope "/", TransactionsMonoWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", TransactionsMonoWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings/update_password", UserSettingsController, :update_password
    put "/users/settings/update_email", UserSettingsController, :update_email
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", TransactionsMonoWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
