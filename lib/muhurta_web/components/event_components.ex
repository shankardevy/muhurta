defmodule MuhurtaWeb.EventComponents do
  use Phoenix.Component

  @doc """
  Renders an Event Poll
  """

  attr :poll, :map, required: true
  attr :rest, :global, default: %{class: "px-8 py-4 bg-white rounded-lg shadow-md"}

  slot :inner_block
  slot :name
  slot :location

  def poll_card(assigns) do
    ~H"""
    <div {@rest}>
      <div class="flex items-center justify-between">
        <%= render_slot(@location) %>
      </div>
      <div class="mt-2">
        <%= render_slot(@name) %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
