defmodule MuhurtaWeb.EventComponents do
  use Phoenix.Component

  import MuhurtaWeb.CoreComponents, only: [icon: 1]
  embed_templates "events/*"

  @doc """
  Renders an Event Poll
  """

  attr :poll, :map, required: true
  attr :rest, :global, default: %{class: "group px-8 py-4 bg-white rounded-lg shadow-md"}

  slot :inner_block
  slot :name
  slot :location

  def poll_card(assigns)

  @doc """
  Renders an user profile card
  """
  attr :email, :string, required: true
  slot :inner_block

  def profile_card(assigns)
end
