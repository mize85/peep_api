defmodule Peep.MessageController do
  use Peep.Web, :controller

  require Logger

  alias Peep.Message


  plug Guardian.Plug.EnsureAuthenticated, handler: Peep.AuthErrorHandler

  def index(conn, %{"room_id" => room_id} = filters) do
    messages = Repo.all(Message) |> Repo.preload :author
    render(conn, "index.json-api", data: messages)
  end

  def index(conn, %{"user_id" => user_id} = filters) do
    messages = Repo.all(Message) |> Repo.preload :author
    render(conn, "index.json-api", data: messages)
  end

  def create(conn, %{"data" => %{"type" => "messages", "attributes" => message_params, "relationships" => %{"author" => _, "room" => %{"data" => %{"id" => room_id, "type" => "rooms"}}}}}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)
    room = Repo.get(Peep.Room, room_id)
    changeset = Message.changeset(%Message{author_id: current_user.id, room_id: room.id}, message_params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(conn, room, message)
        conn
        |> put_status(:created)
        |> put_resp_header("location", message_path(conn, :show, message))
        |> render("show.json-api", data: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peep.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.json-api", data: message)
  end

  def update(conn, %{"id" => id, "data" => %{"id" => _, "type" => "messages", "attributes" => message_params}}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message, message_params)

    case Repo.update(changeset) do
      {:ok, message} ->
        render(conn, "show.json-api", data: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peep.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    Repo.delete!(message)
    send_resp(conn, :no_content, "")
  end

  def broadcast_message(conn, room, message) do

    user = Guardian.Plug.current_resource(conn)

    Logger.debug"> USER #{inspect user.id}"
    Logger.debug"> AUTHOR #{inspect message.author_id}"


    payload = JaSerializer.format(Peep.MessageView, message, conn)
    Peep.Endpoint.broadcast("room:#{room.name}", "new:msg", %{payload: payload, author_id: message.author_id})
  end
end