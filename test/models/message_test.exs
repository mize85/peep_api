defmodule Peep.MessageTest do
  use Peep.ModelCase

    alias Peep.Message
    alias Peep.Room
    alias Peep.User
  
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
