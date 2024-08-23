defmodule MuhurtaWeb.EventComponents do
  use Phoenix.Component

  embed_templates "events/*"

  @doc """
  Renders an Event Poll
  """

  attr :poll, :map, required: true
  attr :rest, :global, default: %{class: "px-8 py-4 bg-white rounded-lg shadow-md"}

  slot :inner_block
  slot :name
  slot :location

  def poll_card(assigns)
end
