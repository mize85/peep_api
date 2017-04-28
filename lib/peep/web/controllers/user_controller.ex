defmodule Peep.Web.UserController do
    use Peep.Web, :controller

    require Logger

    alias Peep.Web.User
    plug Guardian.Plug.EnsureAuthenticated, handler: Peep.Web.AuthErrorHandler

    def index(conn, _params) do
        users = Repo.all(User)
        render(conn, "index.json-api", data: users)
    end

    def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        render(conn, "show.json-api", data: user)
    end

    def update(conn, %{"id" => id, "data" => %{"id" => _, "type" => "users", "attributes" => attributes}}) do

      user = Repo.get!(User, id)
      changeset = User.changeset_update(user, attributes)

      case Repo.update(changeset) do
        {:ok, user} ->
          render(conn, "show.json-api", data: user)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Peep.Web.ChangesetView, "error.json-api", changeset: changeset)
      end
    end

    def current(conn, _) do
      user = conn
        |> Guardian.Plug.current_resource
  
      conn
        |> render(Peep.Web.UserView, "show.json-api", data: user)
    end
end