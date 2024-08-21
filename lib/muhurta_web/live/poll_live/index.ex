defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  # `conn` and `socket` are two distinct states: conn for http and socket for websocket
  #
  # When a LiveView is mounted, it doesn't have access to the previous conn.assigns used in the http connection.
  # It can only access what is set in the session via `put_session`
  #
  # Due to this even though `current_user` is set in conn.assigns during the initial pipeline request in `router.ex`,
  # LiveView doesn't have access to this state once it switches over to WebSocket communication.
  # Therefore, it is necessary to load the current_user again from the session to maintain state
  # and ensure the LiveView can function independently of the conn.

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    {:ok,
     socket
     |> assign(:polls, polls)
     |> assign(:current_user, user)}
  end
end
