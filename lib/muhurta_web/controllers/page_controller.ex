defmodule MuhurtaWeb.PageController do
  use MuhurtaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
