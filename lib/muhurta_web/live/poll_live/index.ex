defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  import MuhurtaWeb.EventComponents

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    socket = stream(socket, :polls, polls)

    {:ok, assign(socket, current_user: user)}
  end

  def handle_event("add_poll", _unsigned_params, socket) do
    poll_params = %{
      name: "New Poll Added by the button",
      location: "Client's Office - Downtown",
      description:
        "Finding the best time to present our latest project deliverables to the client and gather their feedback."
    }

    poll = Events.create_poll!(poll_params, actor: socket.assigns.current_user)

    {:noreply,
     socket |> stream_insert(:polls, poll, at: 0) |> put_flash(:info, "New Event created.")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    :ok = Muhurta.Events.delete_poll(id)

    {:noreply,
     stream_delete_by_dom_id(socket, :polls, "polls-#{id}") |> put_flash(:info, "Event deleted")}
  end
end
