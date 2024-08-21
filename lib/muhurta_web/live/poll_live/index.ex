defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    {:ok, assign(socket, polls: polls, current_user: user)}
  end
end
