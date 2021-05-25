defmodule TransactionsMono.Utils.Formatter do
  def number_to_currency(price) do
    Number.Currency.number_to_currency(price, precision: 0)
  end
end
