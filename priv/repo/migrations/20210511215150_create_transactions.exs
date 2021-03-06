defmodule TransactionsMono.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_from_id, references(:users)
      add :user_to_id, references(:users)
      add :amount, :decimal
      add :date_transaction, :utc_datetime
      add :description, :string

      timestamps()
    end
  end
end
