defmodule MuhurtaWeb.ProcessLive.Show do
  use MuhurtaWeb, :live_view

  def mount(_params, _, socket) do
    {:ok, socket, layout: false}
  end
end
