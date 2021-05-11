defmodule TransactionsMono.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_from, :integer
      add :user_to, :integer
      add :amount, :float
      add :date_transaction, :naive_datetime
      add :description, :string

      timestamps()
    end

  end
end
