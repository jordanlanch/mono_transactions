defmodule TransactionsMonoWeb.Api.TransactionsController do
  use TransactionsMonoWeb, :controller

  alias TransactionsMono.Accounts.User
  alias TransactionsMono.{Accounts, HelperTransactions}
  alias TransactionsMono.HelperTransactions.Transactions

  action_fallback TransactionsMonoWeb.FallbackController

  def index(conn, %{"id_user" => id_user}) do
    transactions = HelperTransactions.get_owner_transactions(id_user)
    render(conn, "index.json", transactions: transactions)
  end

  def create(
        %{private: %{:guardian_default_resource => %TransactionsMono.Accounts.User{id: id}}} =
          conn,
        %{"transaction" => transactions_params, "id_user" => id_user}
      ) do
    with :ok <- validate_owner("#{id}", id_user),
         {:ok, transaction_params_ok} <- add_ids_to_transaction(transactions_params, id),
         {:ok, %Transactions{id: id}} <-
           HelperTransactions.create_transactions(transaction_params_ok) do
      transaction = HelperTransactions.get_transaction_by_id(id)

      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.api_transactions_path(conn, :show, id, transaction.id)
      )
      |> render("show.json", transaction: transaction)
    end
  end

  def show(
        %{private: %{:guardian_default_resource => %TransactionsMono.Accounts.User{id: id}}} =
          conn,
        %{"id_transaction" => id_transaction, "id_user" => id_user}
      ) do
    with :ok <- validate_owner("#{id}", id_user) do
      transaction = HelperTransactions.get_transaction_by_id(id_transaction)
      render(conn, "show.json", transaction: transaction)
    end
  end

  defp validate_owner(id, id_user),
    do: if(id == id_user, do: :ok, else: {:error, "You are not owner of this account"})

  defp add_ids_to_transaction(%{"email" => email} = transactions_params, id_user) do
    case Accounts.get_user_by_email(email) do
      %User{} = user ->
        {:ok,
         transactions_params |> Map.put("user_from_id", id_user) |> Map.put("user_to_id", user.id)}

      nil ->
        {:error, "Email don't exists"}
    end
  end
end
