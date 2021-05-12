defmodule TransactionsMonoWeb.Api.TransactionsView do
  use TransactionsMonoWeb, :view
  alias TransactionsMonoWeb.Api.TransactionsView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionsView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionsView, "transaction.json")}
  end

  def render("transaction.json", %{transactions: transactions}) do
    %{id: transactions.id,
      amount: transactions.amount,
      date_transaction: transactions.date_transaction,
      description: transactions.description,
      user_from_id: transactions.user_from.id,
      user_to_id: transactions.user_to.id
    }
  end
end
