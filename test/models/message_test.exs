defmodule Peep.MessageTest do
  use Peep.Web.DataCase

    alias Peep.Web.Message
    alias Peep.Web.Room
    alias Peep.Web.User
  
    test "empty params" do
      changeset = Message.changeset(%Message{}, %{})
      refute changeset.valid?
    end
  
    test "only body" do
      changeset = Message.changeset(%Message{}, %{body: "some content"})
      refute changeset.valid?
    end
  
    test "only body and author" do
      user = %User{}
      changeset = Message.changeset(%Message{author_id: user.id}, %{body: "some content"})
      refute changeset.valid?
    end

    test "body room and author" do
      user = %User{}
      room = %Room{}
      changeset = Message.changeset(%Message{author_id: user.id, room_id: room.id}, %{body: "some content"})
      refute changeset.valid?
    end
end
