defmodule MuhurtaWeb.Components.Calendar do
  use MuhurtaWeb, :live_component

  attr :calendar_days, :list
  attr :path, :string
  attr :today, :map

  def calendar(assigns) do
    ~H"""
    <div>
      <div class="flex items-center text-center text-gray-900">
        <div class="flex-auto text-sm font-semibold"><%= month_name(@today.month) %></div>
      </div>
      <div class="mt-6 grid grid-cols-7 text-xs text-center leading-6 text-gray-500">
        <div>M</div>
        <div>T</div>
        <div>W</div>
        <div>T</div>
        <div>F</div>
        <div>S</div>
        <div>S</div>
      </div>
      <div class="grid grid-cols-7 gap-px text-sm shadow" phx-update="stream" id="calendar-month">
        <div :for={{stream_id, cell} <- @calendar_days} id={stream_id}>
          <.cell
            day={cell.date.day}
            is_today={cell.is_today}
            dynamic_attrs={get_dynamic_attrs(cell, @path)}
          />
        </div>
      </div>
    </div>
    """
  end

  attr :dynamic_attrs, :list, required: true
  attr :day, :integer, required: true
  attr :is_today, :boolean, required: true

  def cell(assigns) do
    ~H"""
    <button type="button" {@dynamic_attrs}>
      <time class={
        if @is_today,
          do:
            "mx-auto flex h-7 w-7 items-center justify-center rounded-full bg-gray-900 font-semibold text-white",
          else: "mx-auto flex h-7 w-7 items-center justify-center rounded-full"
      }>
        <%= @day %>
      </time>
    </button>
    """
  end

  # disabled class: "text-gray-300 bg-gray-50"
  # enabled class: "text-gray-900 bg-white hover:bg-gray-100 "
  # highlighted class: "text-indigo-600 bg-indigo-300 hover:bg-indigo-200 font-bold"
  def get_dynamic_attrs(cell, path) do
    class =
      "w-full h-full " <>
        case {cell.is_enabled, cell.is_highlighted} do
          {true, true} -> "text-indigo-600 bg-indigo-300 hover:bg-indigo-200 font-bold "
          {true, _} -> "text-gray-900 bg-white hover:bg-gray-100 "
          {false, true} -> "text-indigo-600 bg-indigo-300 font-bold "
          _ -> "text-gray-300 bg-gray-50 "
        end

    phx_attrs =
      if cell.is_enabled do
        [
          "phx-click": "add_option",
          "phx-value-path": path,
          "phx-value-date": cell.date
        ]
      else
        [disabled: true]
      end

    [class: class] ++ phx_attrs
  end

  def build_cells(given_day, selected_days) do
    first_date =
      given_day
      |> Date.beginning_of_month()
      |> Date.beginning_of_week()

    last_date =
      given_day
      |> Date.end_of_month()
      |> Date.end_of_week()

    Date.range(first_date, last_date)
    |> Enum.map(fn day ->
      build_cell(day, selected_days)
    end)
  end

  def build_cell(day, selected_days) do
    %{
      date: day,
      is_enabled: is_day_enabled(day, selected_days),
      is_highlighted: is_selected(day, selected_days),
      is_today: is_today(day)
    }
  end

  defp is_day_enabled(day, selected_days),
    do: (is_today(day) || is_future_day(day)) && !is_selected(day, selected_days)

  defp is_today(day), do: Date.compare(Date.utc_today(), day) == :eq

  defp is_future_day(day), do: Date.diff(day, Date.utc_today()) > 0
  defp is_selected(day, selected_days), do: Enum.member?(selected_days, day)

  def month_name(1), do: "January"
  def month_name(2), do: "February"
  def month_name(3), do: "March"
  def month_name(4), do: "April"
  def month_name(5), do: "May"
  def month_name(6), do: "June"
  def month_name(7), do: "July"
  def month_name(8), do: "August"
  def month_name(9), do: "September"
  def month_name(10), do: "October"
  def month_name(11), do: "November"
  def month_name(12), do: "December"
end

# Send a date to a calendar component
# generate a stream of dates
# manage the internal state of selected dates
# disable past dates

# date:
# think of possible states for a specific day:
# disabled or enabled
# highlighted

# disabled:
# - day is in past OR
# - day is in one of the previously selected dates

# enabled:
# - day is in future or today AND
# - day is NOT one of the previously selected dates

# highlighted:
# - today OR
# - day is in one of the previously selected dates

# disabled class: "text-gray-300 bg-gray-50"
# disabled tag: <span>
# enabled class: "text-gray-900 bg-white hover:bg-gray-100 "
# enabled tag: <button>

# highlighted class: "text-indigo-600 bg-indigo-300 hover:bg-indigo-200 font-bold"
