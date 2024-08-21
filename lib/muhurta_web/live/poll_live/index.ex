defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  # Importing `MuhurtaWeb.EventComponents` in this LiveView module allows us
  # to use the function components defined in `MuhurtaWeb.EventComponents` in our
  # template files in the shorthand format like `<.poll_card />` instead of the long
  # format of using `<MuhurtaWeb.EventComponents.poll_card />`.
  import MuhurtaWeb.EventComponents

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    {:ok, assign(socket, polls: polls, current_user: user)}
  end
end
