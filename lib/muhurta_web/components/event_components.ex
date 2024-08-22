defmodule MuhurtaWeb.EventComponents do
  use Phoenix.Component

  @doc """
  Renders an Event Poll
  """

  attr :poll, :map, required: true
  attr :rest, :global, default: %{class: "px-8 py-4 bg-white rounded-lg shadow-md"}
  slot :inner_block

  def poll_card(assigns) do
    ~H"""
    <div {@rest}>
      <div class="flex items-center justify-between">
        <span class="text-sm font-light text-gray-600"><%= @poll.location %></span>
      </div>
      <div class="mt-2">
        <a href="#" class="text-xl font-bold text-gray-700 hover:text-gray-600 hover:underline">
          <%= @poll.name %>
        </a>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
