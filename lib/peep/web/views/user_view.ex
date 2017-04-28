defmodule Peep.Web.UserView do
    use Peep.Web, :view
      use JaSerializer.PhoenixView

      attributes [:email, :avatar_url, :thumb_url]
      has_many :rooms, link: :rooms_link
      has_many :messages, link: :messages_link
    
      def rooms_link(user, conn) do
        user_rooms_path(conn, :index, user.id)
      end
    
      def messages_link(user, conn) do
        user_messages_path(conn, :index, user.id)
      end

      def avatar_url(user, conn) do
        Peep.Web.Avatar.url({user.avatar, user}, :original)
      end

      def thumb_url(user, conn) do
        Peep.Web.Avatar.url({user.avatar, user}, :thumb)
      end
end