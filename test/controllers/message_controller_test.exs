defmodule Peep.MessageControllerTest do
  use Peep.Web.ConnCase

  alias Peep.Web.Message
  alias Peep.Web.Room

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %Peep.Web.User{}
    other_user = Repo.insert! %Peep.Web.User{}
    room1 = Repo.insert! %Room{owner_id: user.id}
    room2 = Repo.insert! %Room{owner_id: other_user.id}
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)
    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json")
    |> put_req_header("authorization", "Bearer #{jwt}")
 
    {:ok, %{conn: conn, user: user, rooms: [room1, room2]}}
  end

  test "lists messages for user", %{conn: conn, user: user, rooms: _rooms} do
    conn = get conn, user_messages_path(conn, :index, user.id)
    assert json_response(conn, 200)["data"] == []
  end
  
  test "lists messages for room", %{conn: conn, user: _user, rooms: rooms} do
    room = rooms |> hd
    conn = get conn, room_messages_path(conn, :index, room.id)
    assert json_response(conn, 200)["data"] == []
  end  

  test "shows chosen resource", %{conn: conn, user: user, rooms: rooms} do
    room = rooms |> hd
    message = Repo.insert! %Message{author_id: user.id, room_id: room.id, body: "hi"}
    conn = get conn, message_path(conn, :show, message)
    assert json_response(conn, 200)["data"]["id"]
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, user: _user, rooms: _rooms} do
    assert_error_sent 404, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: _user, rooms: rooms} do
    room = rooms |> hd    
    conn = post conn, room_messages_path(conn, :create, room.id), data: %{type: "messages", attributes: @valid_attrs, relationships: %{"author" => %{}, "room" => %{"data" => %{"id" => room.id, "type" => "rooms"}}}}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: _user, rooms: rooms} do
    room = rooms |> hd
    conn = post conn, room_messages_path(conn, :create, room.id), data: %{type: "messages", attributes: @invalid_attrs,  relationships: %{"author" => %{}, "room" => %{"data" => %{"id" => room.id, "type" => "rooms"}}}}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user, rooms: rooms} do
    room = rooms |> hd
    message = Repo.insert! %Message{author_id: user.id, room_id: room.id}
    conn = put conn, message_path(conn, :update, message), data: %{type: "messages", id: message.id, attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: _user, rooms: _rooms} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), data: %{type: "messages", id: message.id, attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user, rooms: rooms} do
    room = rooms |> hd
    message = Repo.insert! %Message{room_id: room.id, author_id: user.id}
    conn = delete conn, message_path(conn, :delete, message)
    assert response(conn, 204)
    refute Repo.get(Message, message.id)
  end
end