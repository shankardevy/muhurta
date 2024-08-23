defmodule MuhurtaWeb.PollLive.Show do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(%{"id" => id}, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    if connected?(socket), do: MuhurtaWeb.Endpoint.subscribe(poll_topic(id))

    {:ok, assign(socket, current_user: user)}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    poll = Events.get_poll!(id)

    {:noreply, assign(socket, :poll, poll)}
  end

  def handle_info({:user_vote, vote}, socket) do
    poll = Events.get_poll!(socket.assigns.poll.id)

    :ok =
      MuhurtaWeb.Endpoint.broadcast_from(self(), poll_topic(poll.id), "voted", %{
        user: socket.assigns.current_user
      })

    {:noreply, assign(socket, :poll, poll) |> put_flash(:info, "Voted")}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "voted", payload: %{user: user}}, socket) do
    {:noreply, put_flash(socket, :info, "Voted by #{user.name}")}
  end

  defp poll_topic(id), do: "poll-#{id}"

  defp group_votes(votes) do
    grouped = Enum.group_by(votes, & &1.answer)

    # Define the order of groups
    order = ["If Need Be", "No", "Yes"]

    Enum.reduce(order, [], fn answer, acc ->
      [{answer, Map.get(grouped, answer, [])}] ++ acc
    end)
  end
end
