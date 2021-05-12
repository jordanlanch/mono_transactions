defmodule TransactionsMonoWeb.PageControllerTest do
  use TransactionsMonoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "A virtual card to make your company fly with"
  end
end
