defmodule MuhurtaWeb.PollLive.Form do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    {:ok, assign(socket, current_user: user)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, form: get_poll_form(params, socket.assigns.current_user))}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form,
           params: params
         ) do
      {:ok, poll} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event Poll created")
         |> push_navigate(to: ~p"/polls/#{poll.id}")}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end

  defp get_poll_form(_params, user) do
    Muhurta.Events.Poll
    |> AshPhoenix.Form.for_create(:create, actor: user)
    |> to_form()
  end
end
