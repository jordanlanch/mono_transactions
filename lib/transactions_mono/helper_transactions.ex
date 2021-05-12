defmodule TransactionsMono.HelperTransactions do
  @moduledoc """
  The HelperTransactions context.
  """

  import Ecto.Query, warn: false
  alias TransactionsMono.Repo

  alias TransactionsMono.HelperTransactions.Transactions
  alias TransactionsMono.Utils.Formatter

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transactions{}, ...]

  """
  def list_transactions() do
    Repo.all(from t in Transactions, preload: [:user_to, :user_from])
  end

  @doc """
  Gets a single transactions.

  Raises `Ecto.NoResultsError` if the Transactions does not exist.

  ## Examples

      iex> get_transactions!(123)
      %Transactions{}

      iex> get_transactions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transactions!(id), do: Repo.get!(Transactions, id)

  @doc """
  Creates a transactions.

  ## Examples

      iex> create_transactions(%{field: value})
      {:ok, %Transactions{}}

      iex> create_transactions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transactions(attrs \\ %{}) do
    %Transactions{}
    |> Transactions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transactions.

  ## Examples

      iex> update_transactions(transactions, %{field: new_value})
      {:ok, %Transactions{}}

      iex> update_transactions(transactions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transactions(%Transactions{} = transactions, attrs) do
    transactions
    |> Transactions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transactions.

  ## Examples

      iex> delete_transactions(transactions)
      {:ok, %Transactions{}}

      iex> delete_transactions(transactions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transactions(%Transactions{} = transactions) do
    Repo.delete(transactions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transactions changes.

  ## Examples

      iex> change_transactions(transactions)
      %Ecto.Changeset{data: %Transactions{}}

  """
  def change_transactions(%Transactions{} = transactions, attrs \\ %{}) do
    Transactions.changeset(transactions, attrs)
  end

  def get_owner_transactions(user_id) do
    from(t in Transactions,
      join: u_to in assoc(t, :user_to),
      join: u_from in assoc(t, :user_from),
      where: u_to.id == ^user_id,
      preload: [user_to: u_to, user_from: u_from]
    )
    |> Repo.all()
  end

  def get_transaction_by_id(id) do
    from(t in Transactions,
      join: u_to in assoc(t, :user_to),
      join: u_from in assoc(t, :user_from),
      where: t.id == ^id,
      preload: [user_to: u_to, user_from: u_from]
    )
    |> Repo.one()
  end

  def sum_balance_owner_transactions(user_id) do
    from(t in Transactions,
      join: u in assoc(t, :user_to),
      where: u.id == ^user_id,
      select: sum(t.amount)
    )
    |> Repo.one()
    |> case do
      nil ->
        0

      value ->
        value
        |> trunc()
        |> Formatter.format_number(",")
    end
  end
end
