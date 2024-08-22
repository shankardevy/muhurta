defmodule MuhurtaWeb.PollLive.Assigns do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  import MuhurtaWeb.EventComponents

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    pid = self()
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    {:ok, assign(socket, polls: polls, current_user: user, pid: pid)}
  end

  def handle_event("add_poll", _unsigned_params, socket) do
    poll_params = %{
      name: "New Poll Added by the button",
      location: "Client's Office - Downtown",
      description:
        "Finding the best time to present our latest project deliverables to the client and gather their feedback."
    }

    Events.create_poll!(poll_params, actor: socket.assigns.current_user)

    polls = Events.list_polls!()

    {:noreply, socket |> assign(polls: polls) |> put_flash(:info, "New Event created.")}
  end
end
