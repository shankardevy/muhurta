defmodule MuhurtaWeb.Router do
  use MuhurtaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MuhurtaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :logout
    plug :set_session_user_id
    plug :fetch_current_actor
  end

  # Use this scope for paths that can be seen by anonmyous user
  scope "/", MuhurtaWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Use this scope for paths that require authentication
  scope "/", MuhurtaWeb do
    pipe_through [:browser, :require_authentication]

    live "/polls", PollLive.Index
  end

  # Following are custom plugs to implement a simple authentication check
  # for the purpose of the Elixir training. They are not production standards by any means.
  # Each plug handles a different part of the user session and authentication lifecycle,
  # such as logging in, tracking the current user, ensuring authentication, and logging out.

  @doc """
  It logs in a user by finding their ID based on their email and storing that ID in the session for later use.

  This function tries to find a user by their email address, and if successful, stores their `user_id` in the session.
  Here’s how it works:
    - It looks for the "email" in the request parameters. e.g., URL ending with query string `?email=user@example.com`
    - If an email is found and a user with that email exists, it saves the `user_id` to the session.
    - If an email isn't found or the user doesn't exist, it just returns the connection as-is without making any changes.
  """
  def set_session_user_id(conn, _) do
    with email when not is_nil(email) <- Map.get(conn.params, "email"),
         {:ok, %{id: user_id, name: name}} <- Muhurta.Events.get_user_by_email(email) do
      conn
      |> put_session("user_id", user_id)
      |> put_flash(:info, "Logged in as #{name}")
      |> redirect(to: "/")
      |> halt()
    else
      _ -> conn
    end
  end

  @doc """
  It fetches the current logged-in user and makes that information available for the rest of the request.

  This function retrieves the currently logged-in user based on the `user_id` stored in the session
  and assigns it to the connection for use throughout the request.
  Here’s how it works:
  - It looks for the `user_id` in the session.
  - If found, it retrieves the user associated with that ID.
  - It then assigns this user to the `:current_user` and sets them as the "actor" (current user) for any further actions.
  """
  def fetch_current_actor(conn, _) do
    case get_session(conn, "user_id") do
      nil ->
        conn
        |> assign(:current_user, nil)

      user_id ->
        case Muhurta.Events.get_user(user_id) do
          {:ok, user} ->
            conn
            |> assign(:current_user, user)
            |> Ash.PlugHelpers.set_actor(user)

          _ ->
            conn
            |> put_flash(:error, "Invalid Session Details")
            |> redirect(to: "/?logout=true")
            |> halt()
        end
    end
  end

  @doc """
  It blocks access to certain pages unless the user is logged in and redirects them if they are not.

  This function checks if a user is logged in. If no user is logged in, it redirects the request to the homepage and shows an error message.

  Here’s how it works:
  - It checks if a user (or "actor") is set in the connection.
  - If no user is found, it flashes an error saying the user needs to log in and redirects them to the homepage.
  - If a user is found, it allows the request to continue as normal.
  """
  def require_authentication(conn, _) do
    case Ash.PlugHelpers.get_actor(conn) do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access this page")
        |> redirect(to: "/")
        |> halt()

      _ ->
        conn
    end
  end

  @doc """
  It logs the user out if they request to do so and redirects them to the homepage.

  This function logs out the user by clearing their session if a "logout" parameter is present.

  Here’s how it works:
  - It checks if the request contains a "logout" parameter.
  - If the parameter exists, it clears the user session, renews the session ID for security, and redirects the user to the homepage.
  - If the "logout" parameter is not present, it does nothing and continues as usual.
  """
  def logout(conn, _) do
    case Map.has_key?(conn.params, "logout") do
      true ->
        conn
        |> configure_session(renew: true)
        |> clear_session()
        |> redirect(to: "/")
        |> halt()

      _ ->
        conn
    end
  end

  # Following code comes in with default Phoenix installation.
  # We will use it inspect LiveView memory usage.
  if Application.compile_env(:muhurta, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MuhurtaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
