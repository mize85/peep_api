defmodule Peep.MessageView do
  use Peep.Web, :view
  use JaSerializer.PhoenixView

  attributes [:body, :inserted_at, :updated_at]
  has_one :author, link: :author_link
  has_one :room, link: :room_link

  def author_link(message, conn) do
    user_path(conn, :show, message.author_id)
  end
  
  def room_link(message, conn) do
    room_path(conn, :show, message.room_id)
  end
end