defmodule Peep.UserView do
    use Peep.Web, :view
    use JaSerializer.PhoenixView

    attributes [:email]
    has_many :rooms, link: :rooms_link

    def rooms_link(user, conn) do
      user_rooms_url(conn, :index, user.id)
    end
end