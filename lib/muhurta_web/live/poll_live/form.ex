defmodule MuhurtaWeb.PollLive.Form do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events
  alias MuhurtaWeb.Components.Calendar

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    socket =
      socket
      |> assign(:selected_days, [])
      |> stream_configure(:calendar_days, dom_id: &"day-#{&1.date}")

    {:ok, assign(socket, current_user: user)}
  end

  def handle_params(params, _uri, socket) do
    today = Date.utc_today()
    selected_days = []

    calendar_days = Calendar.build_cells(today, selected_days)

    socket =
      socket
      |> stream(:calendar_days, calendar_days)

    {:noreply,
     assign(socket,
       today: today,
       selected_days: selected_days,
       form: get_poll_form(params, socket.assigns.current_user)
     )}
  end

  def handle_event("delete_option", %{"path" => path}, socket) do
    form = AshPhoenix.Form.remove_form(socket.assigns.form, path)

    {:noreply, assign(socket, :form, form)}
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

  def handle_event("add_option", %{"path" => path, "date" => date}, socket) do
    selected_date = Date.from_iso8601!(date)

    form =
      AshPhoenix.Form.add_form(socket.assigns.form, path,
        params: %{date: date, from_time: "13:00:00", to_time: "14:00:00"}
      )

    selected_days = socket.assigns.selected_days ++ [selected_date]
    calendar_day = Calendar.build_cell(selected_date, selected_days)
    IO.inspect(calendar_day, label: "CD")

    socket =
      socket
      |> assign(:selected_days, selected_days)
      |> stream_insert(:calendar_days, calendar_day)

    {:noreply, assign(socket, :form, form)}
  end

  defp get_poll_form(_params, user) do
    Muhurta.Events.Poll
    |> AshPhoenix.Form.for_create(:create, forms: [auto?: true], actor: user)
    |> to_form()
  end
end
