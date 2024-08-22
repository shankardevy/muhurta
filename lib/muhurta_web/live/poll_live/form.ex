defmodule MuhurtaWeb.PollLive.Form do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    {:ok, assign(socket, current_user: user)}
  end
end
