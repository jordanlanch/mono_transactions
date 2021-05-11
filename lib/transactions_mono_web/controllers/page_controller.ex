defmodule TransactionsMonoWeb.PageController do
  use TransactionsMonoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
