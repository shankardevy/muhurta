defmodule MuhurtaWeb.PollLive.Index do
  use MuhurtaWeb, :live_view

  alias Muhurta.Events

  def mount(_params, %{"user_id" => user_id} = _session, socket) do
    polls = Events.list_polls!()
    user = Muhurta.Events.get_user!(user_id)

    # In Elixir, keyword lists are defined with a square brackets like this:
    #
    # [name: "chaaru", favorite_animal: "all animals"]`
    #
    # However, when passing this list as a last argument to a function, it can be
    # written without brackets like: some_func_call(first_arg, name: "chaaru", favorite_animal: "all animals")
    #
    # which is same as: some_func_call(first_arg, [name: "chaaru", favorite_animal: "all animals"])
    #
    # This is the reason why assign(socket, polls: polls, current_user: user) looks like
    # it's taking more arguments than it actually is. When in fact the second argument is just a single keyword list.

    {:ok, assign(socket, polls: polls, current_user: user)}
  end
end
