defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, _session, socket) do
    polls = Events.list_polls!()
    socket = assign(socket, :polls, polls)

    {:ok, socket}

    # In practice, you might see code like this
    # which does exactly the same thing as above
    # with less lines of code:
    #
    # {:ok, assign(socket, :polls, Events.list_polls!())}

    # or you might see something like this if you are setting
    # multiple variables in assigns
    #
    # {:ok,
    #  socket
    #  |> assign(:polls, Events.list_polls!())
    #  |> assign(:something_else, "some value")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-6 pb-2 text-2xl font-semibold text-gray-800 md:text-3xl border-b border-gray-300">
      Event Polls
    </h1>

    <div class="grid grid-cols-2 gap-4">
      <div :for={poll <- @polls} class="px-8 py-4 bg-white rounded-lg shadow-md">
        <div class="flex items-center justify-between">
          <span class="text-sm font-light text-gray-600"><%= poll.location %></span>
        </div>
        <div class="mt-2">
          <a href="#" class="text-xl font-bold text-gray-700 hover:text-gray-600 hover:underline">
            <%= poll.name %>
          </a>
          <p class="mt-2 text-gray-600"><%= poll.description %></p>
        </div>
      </div>
    </div>
    """
  end
end
