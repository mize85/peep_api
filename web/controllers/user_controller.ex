defmodule Peep.UserController do
  use Peep.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Peep.AuthErrorHandler

  def current(conn, _) do
    user = conn
    |> Guardian.Plug.current_resource

    conn
    |> render(Peep.UserView, "show.json", user: user)
  end
end