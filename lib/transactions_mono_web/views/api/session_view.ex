defmodule TransactionsMonoWeb.Api.SessionView do
  use TransactionsMonoWeb, :view

  def render("create.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        email: user.email,
        id: user.id
      },
      message:
        "You are successfully logged in! Add this token to authorization header to make authorized requests."
    }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end
end
