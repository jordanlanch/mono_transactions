defmodule TransactionsMono.Repo.Migrations.AddDefaultDateTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :date_transaction, :utc_datetime, default: fragment("now()")
    end
  end
end
