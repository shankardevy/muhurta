defmodule MuhurtaWeb.EventComponents do
  use Phoenix.Component

  @doc """
  Renders an Event Poll
  """

  attr :poll, :map, required: true
  attr :class, :string, default: "px-8 py-4 bg-white rounded-lg shadow-md"

  def poll_card(assigns) do
    ~H"""
    <div class={@class}>
      <div class="flex items-center justify-between">
        <span class="text-sm font-light text-gray-600"><%= @poll.location %></span>
      </div>
      <div class="mt-2">
        <a href="#" class="text-xl font-bold text-gray-700 hover:text-gray-600 hover:underline">
          <%= @poll.name %>
        </a>
        <p class="mt-2 text-gray-600"><%= @poll.description %></p>
      </div>
    </div>
    """
  end
end
