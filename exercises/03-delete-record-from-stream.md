# Delete record from stream on /polls

1. Boiler plate code showing the delete icon is already present.
2. Locate where this icon is placed and make the necessary modifications to trigger an event to server.
3. To send additional data while you trigger an event use `phx-value-{param_name}`. The name can be pattern matched as params in `handle_info`.
4. Delete the poll using the function `Muhurta.Events.delete_poll(poll_id)` in `handle_event`
5. Find the appropriate `stream_*` function on the docs https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html and use it to delete the item in html.