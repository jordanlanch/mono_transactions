defmodule TransactionsMono.HelperTransactions.Transactions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :float
    field :date_transaction, :naive_datetime
    field :description, :string
    field :user_from, :integer
    field :user_to, :integer

    timestamps()
  end

  @doc false
  def changeset(transactions, attrs) do
    transactions
    |> cast(attrs, [:user_from, :user_to, :amount, :date_transaction, :description])
    |> validate_required([:user_from, :user_to, :amount, :date_transaction, :description])
  end
end
