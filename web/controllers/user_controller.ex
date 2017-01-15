defmodule Peep.UserController do
  use Peep.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Peep.AuthErrorHandler

    def index(conn, _params) do
        users = Repo.all(User)
        render(conn, "index.json-api", data: users)
    end

    def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        render(conn, "show.json-api", data: user)
    end

    def current(conn, _) do
      user = conn
        |> Guardian.Plug.current_resource
  
      conn
        |> render(Peep.UserView, "show.json-api", data: user)
    end
end