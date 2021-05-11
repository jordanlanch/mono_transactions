defmodule TransactionsMono.HelperTransactionsTest do
  use TransactionsMono.DataCase

  alias TransactionsMono.HelperTransactions

  describe "transactions" do
    alias TransactionsMono.HelperTransactions.Transactions

    @valid_attrs %{amount: 120.5, date_transaction: ~N[2010-04-17 14:00:00], description: "some description", user_from: 42, user_to: 42}
    @update_attrs %{amount: 456.7, date_transaction: ~N[2011-05-18 15:01:01], description: "some updated description", user_from: 43, user_to: 43}
    @invalid_attrs %{amount: nil, date_transaction: nil, description: nil, user_from: nil, user_to: nil}

    def transactions_fixture(attrs \\ %{}) do
      {:ok, transactions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HelperTransactions.create_transactions()

      transactions
    end

    test "list_transactions/0 returns all transactions" do
      transactions = transactions_fixture()
      assert HelperTransactions.list_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transactions = transactions_fixture()
      assert HelperTransactions.get_transactions!(transactions.id) == transactions
    end

    test "create_transactions/1 with valid data creates a transactions" do
      assert {:ok, %Transactions{} = transactions} = HelperTransactions.create_transactions(@valid_attrs)
      assert transactions.amount == 120.5
      assert transactions.date_transaction == ~N[2010-04-17 14:00:00]
      assert transactions.description == "some description"
      assert transactions.user_from == 42
      assert transactions.user_to == 42
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HelperTransactions.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{} = transactions} = HelperTransactions.update_transactions(transactions, @update_attrs)
      assert transactions.amount == 456.7
      assert transactions.date_transaction == ~N[2011-05-18 15:01:01]
      assert transactions.description == "some updated description"
      assert transactions.user_from == 43
      assert transactions.user_to == 43
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transactions = transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = HelperTransactions.update_transactions(transactions, @invalid_attrs)
      assert transactions == HelperTransactions.get_transactions!(transactions.id)
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = HelperTransactions.delete_transactions(transactions)
      assert_raise Ecto.NoResultsError, fn -> HelperTransactions.get_transactions!(transactions.id) end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = HelperTransactions.change_transactions(transactions)
    end
  end
end
