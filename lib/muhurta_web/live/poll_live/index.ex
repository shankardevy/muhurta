defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, _session, socket) do
    polls = Events.list_polls!()

    {:ok, assign(socket, :polls, polls)}
  end
end
