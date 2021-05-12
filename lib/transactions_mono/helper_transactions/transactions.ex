defmodule TransactionsMono.HelperTransactions.Transactions do
  use Ecto.Schema
  import Ecto.Changeset
  alias TransactionsMono.Accounts.User

  schema "transactions" do
    field :amount, :float
    field :date_transaction, :naive_datetime
    field :description, :string

    belongs_to :user_from, User
    belongs_to :user_to, User
    timestamps()
  end

  @doc false
  def changeset(transactions, attrs) do
    transactions
    |> cast(attrs, [:user_from_id, :user_to_id, :amount, :date_transaction, :description])
    |> validate_required([:user_from_id, :user_to_id, :amount, :description])
    |> assoc_constraint(:user_from)
    |> assoc_constraint(:user_to)
  end
end
