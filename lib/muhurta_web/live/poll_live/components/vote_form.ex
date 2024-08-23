defmodule MuhurtaWeb.PollLive.Component.VoteForm do
  use MuhurtaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="mt-4 flex flex-col">
      <.simple_form for={@form} phx-change="submit" phx-target={@myself}>
        <.input
          type="select"
          label="Your availability"
          prompt="Choose"
          options={["Yes", "No", "If Need Be"]}
          field={@form[:answer]}
        />
      </.simple_form>
    </div>
    """
  end

  # On Mount, the Socket.assigns has the following:
  #   Phoenix.LiveView.Socket<
  #   assigns: %{
  #     __changed__: %{flash: true},
  #     flash: %{},
  #     myself: %Phoenix.LiveComponent.CID{cid: 3}
  #   },
  # >
  def mount(socket) do
    {:ok, socket}
  end

  # Here `assigns` contains the values sent the parent LiveView.
  # the `socket` is from mount if on first call otherwise, what is set earlier.
  # i.e., if the `update` below sets n number of values in assigns in the initial call, the subsequent
  # call to `update` by LiveView will have those `n` values in `socket.assigns` and the `assigns` will contain
  # new values set by LiveView.
  def update(assigns, socket) do
    vote_form = get_vote_form(assigns.poll_option, assigns.current_user)

    socket =
      assign(socket, current_user: assigns.current_user, poll_option_id: assigns.poll_option.id)

    {:ok, assign(socket, :form, vote_form)}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    params =
      Map.merge(params, %{
        "user_id" => socket.assigns.current_user.id,
        "poll_option_id" => socket.assigns.poll_option_id
      })

    case AshPhoenix.Form.submit(socket.assigns.form,
           params: params
         ) do
      {:ok, vote} ->
        send(self(), {:user_vote, vote})

        {:noreply,
         socket
         |> put_flash(:info, "Vote created")}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end

  defp get_vote_form(%{votes: []}, user), do: get_new_vote_form(user)

  defp get_vote_form(%{votes: votes}, user) do
    case get_user_vote(votes, user) do
      nil -> get_new_vote_form(user)
      vote -> edit_vote_form(vote, user)
    end
  end

  defp get_new_vote_form(user) do
    Muhurta.Events.Vote
    |> AshPhoenix.Form.for_create(:create, actor: user)
    |> to_form()
  end

  defp edit_vote_form(vote, user) do
    vote
    |> AshPhoenix.Form.for_update(:update, actor: user)
    |> to_form()
  end

  defp get_user_vote(votes, user) do
    Enum.find(votes, &(&1.user_id == user.id))
  end
end
