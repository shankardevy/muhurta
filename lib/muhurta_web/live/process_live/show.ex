defmodule MuhurtaWeb.ProcessLive.Show do
  use MuhurtaWeb, :live_view

  def mount(_params, %{"pid" => pid} = _session, socket) do
    :timer.send_interval(1000, self(), :tick)

    process_details = get_process_details(pid)

    {:ok, assign(socket, process_details), layout: false}
  end

  def handle_info(:tick, socket) do
    process_details = get_process_details(socket.assigns.pid)

    {:noreply, assign(socket, process_details)}
  end

  defp get_process_details(pid) do
    [
      pid: pid,
      memory: get_process_memory(pid),
      status: get_process_state(pid)
    ]
  end

  defp get_process_memory(pid) do
    case Process.info(pid, :memory) do
      {:memory, bytes} ->
        ceil(bytes / 1024)

      nil ->
        "Process not found"
    end
  end

  def get_process_state(pid) do
    case Process.info(pid, :current_function) do
      {:current_function, {:erlang, :hibernate, _}} ->
        "Hibernating"

      {:current_function, {_, _, _}} ->
        "Active"

      _ ->
        "Not found"
    end
  end
end
