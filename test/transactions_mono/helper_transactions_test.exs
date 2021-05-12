defmodule TransactionsMono.HelperTransactionsTest do
  use TransactionsMono.DataCase

  alias TransactionsMono.HelperTransactions

  describe "transactions" do
    setup do
      insert(:user_from, id: 42)
      insert(:user_to, id: 43)
      :ok
    end

    alias TransactionsMono.HelperTransactions.Transactions

    @valid_attrs %{
      amount: 120.5,
      date_transaction: ~N[2010-04-17 14:00:00],
      description: "some description",
      user_from_id: 42,
      user_to_id: 43
    }
    @update_attrs %{
      amount: 456.7,
      date_transaction: ~N[2011-05-18 15:01:01],
      description: "some updated description"
    }
    @invalid_attrs %{
      amount: nil,
      date_transaction: nil,
      description: nil,
      user_from: nil,
      user_to: nil
    }

    def transactions_fixture() do
      insert(:transaction)
    end

    test "list_transactions/0 returns all transactions" do
      transactions = transactions_fixture()
      assert HelperTransactions.list_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transaction = transactions_fixture()
      get_transaction = HelperTransactions.get_transactions!(transaction.id)

      assert get_transaction.amount == transaction.amount
      assert get_transaction.description == transaction.description
      assert get_transaction.id == transaction.id
    end

    test "create_transactions/1 with valid data creates a transactions" do
      assert {:ok, %Transactions{} = transactions} =
               HelperTransactions.create_transactions(@valid_attrs)

      assert transactions.amount == 120.5
      assert transactions.date_transaction == ~N[2010-04-17 14:00:00]
      assert transactions.description == "some description"
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HelperTransactions.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()

      assert {:ok, %Transactions{} = transactions} =
               HelperTransactions.update_transactions(transactions, @update_attrs)

      assert transactions.amount == 456.7
      assert transactions.date_transaction == ~N[2011-05-18 15:01:01]
      assert transactions.description == "some updated description"
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transaction = transactions_fixture()

      assert {:error, %Ecto.Changeset{}} =
               HelperTransactions.update_transactions(transaction, @invalid_attrs)

      get_transaction = HelperTransactions.get_transactions!(transaction.id)

      assert get_transaction.amount == transaction.amount
      assert get_transaction.description == transaction.description
      assert get_transaction.id == transaction.id
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = HelperTransactions.delete_transactions(transactions)

      assert_raise Ecto.NoResultsError, fn ->
        HelperTransactions.get_transactions!(transactions.id)
      end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = HelperTransactions.change_transactions(transactions)
    end
  end
end
