defmodule TransactionsMono.Factory do
  @moduledoc """
  TransactionsMono factories
  """
  # with Ecto
  use ExMachina.Ecto, repo: TransactionsMono.Repo

  alias TransactionsMono.Accounts.User
  alias TransactionsMono.HelperTransactions.Transactions

  def user_from_factory do
    %User{
      email: sequence(:email, &"email-from-#{&1}@example.com"),
      hashed_password: "passwords"
    }
  end

  def user_to_factory do
    %User{
      email: sequence(:email, &"email-to-#{&1}@example.com"),
      hashed_password: "passwords"
    }
  end

  def transaction_factory do
    %Transactions{
      description: sequence(:description, &"description-#{&1}"),
      date_transaction: DateTime.utc_now(),
      amount: 1000,
      user_from: build(:user_from),
      user_to: build(:user_to)
    }
  end
end
