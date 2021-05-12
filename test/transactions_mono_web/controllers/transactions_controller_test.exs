defmodule TransactionsMonoWeb.TransactionsControllerTest do
  use TransactionsMonoWeb.ConnCase

  setup :register_and_log_in_user

  @create_attrs %{
    amount: 120.5,
    date_transaction: ~N[2010-04-17 14:00:00],
    description: "some description",
    user_from_id: 42,
    user_to_id: 43
  }
  @update_attrs %{
    amount: 456.7,
    date_transaction: ~N[2011-05-18 15:01:01],
    description: "some updated description"
  }
  @invalid_attrs %{
    amount: nil,
    date_transaction: nil,
    description: nil,
    user_from: nil,
    user_to: nil
  }

  def fixture(:transactions) do
    insert(:transaction)
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transactions_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transactions"
    end
  end

  describe "new transactions" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transactions_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transactions"
    end
  end

  describe "create transactions" do
    setup do
      insert(:user_from, id: 42)
      insert(:user_to, id: 43)
      :ok
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transactions_path(conn, :create), transactions: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transactions_path(conn, :show, id)

      conn = get(conn, Routes.transactions_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transactions"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transactions_path(conn, :create), transactions: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transactions"
    end
  end

  describe "edit transactions" do
    setup [:create_transactions]

    test "renders form for editing chosen transactions", %{conn: conn, transactions: transactions} do
      conn = get(conn, Routes.transactions_path(conn, :edit, transactions))
      assert html_response(conn, 200) =~ "Edit Transactions"
    end
  end

  describe "update transactions" do
    setup [:create_transactions]

    test "redirects when data is valid", %{conn: conn, transactions: transactions} do
      conn =
        put(conn, Routes.transactions_path(conn, :update, transactions),
          transactions: @update_attrs
        )

      assert redirected_to(conn) == Routes.transactions_path(conn, :show, transactions)

      conn = get(conn, Routes.transactions_path(conn, :show, transactions))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, transactions: transactions} do
      conn =
        put(conn, Routes.transactions_path(conn, :update, transactions),
          transactions: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Transactions"
    end
  end

  describe "delete transactions" do
    setup [:create_transactions]

    test "deletes chosen transactions", %{conn: conn, transactions: transactions} do
      conn = delete(conn, Routes.transactions_path(conn, :delete, transactions))
      assert redirected_to(conn) == Routes.transactions_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.transactions_path(conn, :show, transactions))
      end
    end
  end

  defp create_transactions(_) do
    transactions = fixture(:transactions)
    %{transactions: transactions}
  end
end
