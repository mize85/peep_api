defmodule Peep.AuthErrorHandler do
 use Peep.Web, :controller

 def unauthenticated(conn) do
  conn
   |> put_status(401)
   |> render(Peep.ErrorView, "401.json")
 end

 def unauthorized(conn) do
  conn
   |> put_status(403)
   |> render(Peep.ErrorView, "403.json")
 end
end