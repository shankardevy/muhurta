defmodule MuhurtaWeb.ProfileLive.Show do
  use MuhurtaWeb, :live_view

  import MuhurtaWeb.EventComponents
  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Events.get_user!(user_id)

    {:ok, assign(socket, :current_user, user)}
  end
end
