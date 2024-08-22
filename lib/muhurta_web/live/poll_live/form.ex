defmodule MuhurtaWeb.PollLive.Form do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    poll_form = %{
      name: "",
      location: "",
      description: ""
    }

    {:ok, assign(socket, form: to_form(poll_form), current_user: user)}
  end

  def handle_event("submit", params, socket) do
    Events.create_poll!(params, actor: socket.assigns.current_user)
    {:noreply, put_flash(socket, :info, "Event saved")}
  end
end
