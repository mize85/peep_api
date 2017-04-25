defmodule Peep.Web.UserView do
    use Peep.Web, :view
      use JaSerializer.PhoenixView

      attributes [:email, :avatar]
      has_many :rooms, link: :rooms_link
      has_many :messages, link: :messages_link
    
      def rooms_link(user, conn) do
        user_rooms_path(conn, :index, user.id)
      end
    
      def messages_link(user, conn) do
        user_messages_path(conn, :index, user.id)
      end
end