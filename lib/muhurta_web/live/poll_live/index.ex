defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  # Importing `MuhurtaWeb.EventComponents` in this LiveView module allows us
  # to use the function components defined in `MuhurtaWeb.EventComponents` in our
  # template files in the shorthand format like `<.poll_card />` instead of the long
  # format of using `<MuhurtaWeb.EventComponents.poll_card />`.
  import MuhurtaWeb.EventComponents

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    {:ok, socket |> stream(:polls, polls) |> assign(:current_user, user)}
  end

  def handle_event(_event, _unsigned_params, socket) do
    {:noreply, socket}
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
