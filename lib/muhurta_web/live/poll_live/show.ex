defmodule MuhurtaWeb.PollLive.Show do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(%{"id" => id}, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    poll = Events.get_poll!(id)
    polls = Events.list_polls!()

    socket = stream(socket, :polls, polls)

    {:ok, assign(socket, poll: poll, current_user: user)}
  end
end
