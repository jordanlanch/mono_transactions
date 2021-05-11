defmodule TransactionsMonoWeb.Dashboard.IndexLive do
  use Phoenix.LiveView
  alias TransactionsMonoWeb.BalanceView
  alias TransactionsMonoWeb.Router.Helpers, as: Routes
  alias Ad.Accounts
  alias Ad.Users.{ProfileHelper, User, UserHelper}
  alias Ad.Publications.PublicationHelper

  def mount(_params, %{"assigns" => %{current_user: user}}, socket) do
    if connected?(socket), do: :timer.send_interval(5000, self(), :tick)

    {:ok, assign(socket, user: user, socket: socket)}
  end

  def handle_info(:tick, socket) do
    {publications, global_counters, cnt_publications, cnt_profiles} =
      get_data_dashboard(socket.assigns.user_id)

    {:noreply,
     assign(socket,
       publications: publications,
       global_counters: global_counters,
       cnt_publications: cnt_publications,
       cnt_profiles: cnt_profiles,
       current_user: socket.assigns.current_user,
       user_id: socket.assigns.user_id,
       locale: socket.assigns.locale
     )}
  end

  def handle_event("resend_mail", _value, socket) do
    user = socket.assigns.current_user
    user_id = socket.assigns.user_id

    Accounts.deliver_user_confirmation_instructions(
      user,
      &Routes.user_confirmation_url(socket, :confirm, &1)
    )

    {publications, global_counters, cnt_publications, cnt_profiles} = get_data_dashboard(user_id)

    {:noreply,
     socket
     |> put_flash(
       :info,
       "Your Email has been sended successfully"
     )
     |> assign(
       publications: publications,
       global_counters: global_counters,
       cnt_publications: cnt_publications,
       cnt_profiles: cnt_profiles,
       current_user: socket.assigns.current_user,
       user_id: user_id,
       locale: socket.assigns.locale
     )}
  end

  def render(assigns) do
    BalanceView.render("index.html", assigns)
  end

  defp get_data_dashboard(user_id) do
    publications = PublicationHelper.list_publications_by_user(user_id)
    global_counters = PublicationHelper.counts_publications_by_user(user_id)
    cnt_publications = PublicationHelper.counts_publications(user_id)
    cnt_profiles = ProfileHelper.list_profiles_count(%{user_id: user_id})

    {publications, global_counters, cnt_publications, cnt_profiles}
  end
end
