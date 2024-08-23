defmodule MuhurtaWeb.PollLive.Form do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    user = Events.get_user!(user_id)

    {:ok, assign(socket, current_user: user)}
  end

  def handle_params(params, _uri, socket) do
    today = Date.utc_today()
    calendar = build_calendar_for_day(today)

    {:noreply,
     assign(socket,
       today: today,
       calendar: calendar,
       form: get_poll_form(params, socket.assigns.current_user)
     )}
  end

  def handle_event("delete_option", %{"path" => path}, socket) do
    form = AshPhoenix.Form.remove_form(socket.assigns.form, path)

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("add_option", %{"path" => path, "date" => date}, socket) do
    form =
      AshPhoenix.Form.add_form(socket.assigns.form, path,
        params: %{date: date, from_time: "13:00:00", to_time: "14:00:00"}
      )

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

  defp get_poll_form(_params, user) do
    Muhurta.Events.Poll
    |> AshPhoenix.Form.for_create(:create, forms: [auto?: true], actor: user)
    |> to_form()
  end

  def day(assigns) do
    ~H"""
    <button
      type="button"
      class={[
        "py-1.5 focus:z-10",
        "text-gray-900 bg-white",
        get_day_class(@cell.date, @today)
      ]}
      phx-click="add_option"
      phx-value-path={@path}
      phx-value-date={@cell.date}
    >
      <time class="mx-auto flex h-7 w-7 items-center justify-center rounded-full">
        <%= @cell.date.day %>
      </time>
    </button>
    """
  end

  defp get_day_class(day, today) do
    case Date.compare(day, today) do
      :lt -> "text-gray-300 bg-gray-50"
      :eq -> "text-indigo-600 bg-indigo-300 hover:bg-indigo-200 font-bold"
      :gt -> "text-gray-900 bg-white hover:bg-gray-100 "
    end
  end

  defp build_calendar_for_day(day) do
    first_date =
      day
      |> Date.beginning_of_month()
      |> Date.beginning_of_week()

    last_date =
      day
      |> Date.end_of_month()
      |> Date.end_of_week()

    Date.range(first_date, last_date)
    |> Enum.to_list()
    |> Enum.chunk_every(7)
  end
end
