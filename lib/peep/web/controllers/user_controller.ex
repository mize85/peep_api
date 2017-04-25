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


      Logger.info  "Logging this text!"

      %{"avatar" => avatar} = attributes

      IO.inspect(avatar)


      user = Repo.get!(User, id)
      changeset = User.changeset_update(user, %{"avatar": avatar})

      IO.inspect(user)
      IO.inspect(changeset)

      case Repo.update(changeset) do
        {:ok, user} ->
          render(conn, "show.json-api", data: user)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Peep.Web.ChangesetView, "error.json-api", changeset: changeset)
      end
    end

    def create(conn, %{"id" => id}) do

           Logger.info  "Logging this text!"
            user = Repo.get!(User, id)
            render(conn, "show.json-api", data: user)
        end

    def current(conn, _) do
      user = conn
        |> Guardian.Plug.current_resource
  
      conn
        |> render(Peep.Web.UserView, "show.json-api", data: user)
    end
end