defmodule TransactionsMono.Repo.Migrations.AddDefaultDateTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :date_transaction, :naive_datetime, default: fragment("now()")
    end
  end
end
