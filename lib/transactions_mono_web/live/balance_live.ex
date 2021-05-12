defmodule TransactionsMonoWeb.Dashboard.IndexLive do
  use Phoenix.LiveView
  alias TransactionsMonoWeb.BalanceView
  alias TransactionsMono.HelperTransactions

  def mount(_params, %{"assigns" => %{current_user: user}}, socket) do
    if connected?(socket), do: :timer.send_interval(5000, self(), :tick)

    {transactions, balance} = get_data_dashboard(user.id)

    {:ok,
     assign(socket, user: user, transactions: transactions, balance: balance, socket: socket)}
  end

  def handle_info(:tick, socket) do
    {transactions, balance} = get_data_dashboard(socket.assigns.user.id)

    {:noreply,
     assign(socket,
       user: socket.assigns.user,
       transactions: transactions,
       balance: balance,
       socket: socket
     )}
  end

  def render(assigns) do
    BalanceView.render("index.html", assigns)
  end

  defp get_data_dashboard(user_id) do
    transactions = HelperTransactions.get_owner_transactions(user_id)
    balance = HelperTransactions.sum_balance_owner_transactions(user_id)

    {transactions, balance}
  end
end
