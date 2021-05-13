defmodule TransactionsMonoWeb.Api.TransactionsControllerTest do
  use TransactionsMonoWeb.ConnCase

  setup [:create_user_and_assign_valid_jwt]

  @create_attrs %{
    amount: 120.5,
    date_transaction: ~N[2010-04-17 14:00:00],
    description: "some description"
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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup do
      user_from = insert(:user_from)
      user_to = insert(:user_to)

      insert(:transaction, user_from: user_from, user_to: user_to)
      insert(:transaction, user_from: user_from, user_to: user_to)
      insert(:transaction, user_from: user_from, user_to: user_to)
      {:ok, user_to: user_to}
    end

    test "lists all transactions", %{conn: conn, user_to: user_to} do
      conn = get(conn, Routes.api_transactions_path(conn, :index, user_to.id))
      assert length(json_response(conn, 200)["data"]) == 3
    end
  end

  describe "create transactions" do
    setup do
      insert(:user_from, id: 42)
      user_to = insert(:user_to, id: 43)
      {:ok, user_to: user_to}
    end

    test "renders transactions when data is valid", %{
      conn:
        %{private: %{:guardian_default_resource => %TransactionsMono.Accounts.User{id: id_user}}} =
          conn,
      user_to: user_to
    } do
      create_attrs = Map.put(@create_attrs, :email, user_to.email)

      conn =
        post(conn, Routes.api_transactions_path(conn, :create, id_user), transaction: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_transactions_path(conn, :show, id_user, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "user_from_id" => id_user,
               "user_to_id" => 43,
               "amount" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders transactions when email is not valid", %{
      conn:
        %{private: %{:guardian_default_resource => %TransactionsMono.Accounts.User{id: id_user}}} =
          conn,
      user_to: _
    } do
      create_attrs = Map.put(@create_attrs, :email, "pepe@pepe.com")

      conn =
        post(conn, Routes.api_transactions_path(conn, :create, id_user), transaction: create_attrs)

      assert "Email don't exists" = json_response(conn, 422)["errors"]
    end

    test "renders transactions when user_id is incorrect", %{
      conn: conn,
      user_to: user_to
    } do
      create_attrs = Map.put(@create_attrs, :email, user_to.email)

      conn =
        post(conn, Routes.api_transactions_path(conn, :create, 42), transaction: create_attrs)

      assert "You are not owner of this account" = json_response(conn, 422)["errors"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.api_transactions_path(conn, :create, 42), transaction: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
