defmodule MuhurtaWeb.PollLive.Show do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    polls = Events.list_polls!()

    socket = stream(socket, :polls, polls)

    {:ok, assign(socket, current_user: user)}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    poll = Events.get_poll!(id)

    {:noreply, assign(socket, :poll, poll)}
  end
end
