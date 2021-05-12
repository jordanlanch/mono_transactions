defmodule TransactionsMonoWeb.Api.TransactionsController do
  use TransactionsMonoWeb, :controller

  alias TransactionsMono.HelperTransactions
  alias TransactionsMono.HelperTransactions.Transactions

  action_fallback TransactionsMonoWeb.FallbackController

  def index(conn, %{"id" => id}) do
    transactions = HelperTransactions.get_owner_transactions(id)
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transaction" => transactions_params}) do
    with {:ok, %Transactions{id: id}} <-
           HelperTransactions.create_transactions(transactions_params) do
      transaction = HelperTransactions.get_transaction_by_id(id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_transactions_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = HelperTransactions.get_transaction_by_id(id)
    render(conn, "show.json", transaction: transaction)
  end
end
