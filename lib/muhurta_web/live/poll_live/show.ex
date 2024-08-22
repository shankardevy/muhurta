defmodule MuhurtaWeb.PollLive.Show do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    pid = self()
    user = Events.get_user!(user_id)

    {:ok, assign(socket, current_user: user, pid: pid)}
  end
end
