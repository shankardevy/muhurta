defmodule MuhurtaWeb.PollLive.Show do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    {:ok, assign(socket, current_user: user)}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    poll = Events.get_poll!(id)
    {:noreply, assign(socket, :poll, poll)}
  end

  def handle_info({:user_vote, _vote}, socket) do
    poll = Events.get_poll!(socket.assigns.poll.id)
    {:noreply, assign(socket, :poll, poll)}
  end

  defp group_votes(votes) do
    grouped = Enum.group_by(votes, & &1.answer)

    # Define the order of groups
    order = ["If Need Be", "No", "Yes"]

    Enum.reduce(order, [], fn answer, acc ->
      [{answer, Map.get(grouped, answer, [])}] ++ acc
    end)
  end
end
