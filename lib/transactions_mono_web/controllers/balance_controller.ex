defmodule TransactionsMonoWeb.BalanceController do
  use TransactionsMonoWeb, :controller
  plug :put_layout, "app.html"

  alias Phoenix.LiveView
  alias TransactionsMonoWeb.Dashboard.IndexLive

  def index(
        %Plug.Conn{assigns: assigns} = conn,
        _params
      ) do
    LiveView.Controller.live_render(conn, IndexLive, session: %{"assigns" => assigns})
  end
end
