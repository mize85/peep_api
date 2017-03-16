defmodule Peep.Web.RegistrationController do
  use Peep.Web, :controller

  alias Peep.Web.User

  def create(conn, %{"data" => %{"type" => "users",
    "attributes" => %{"email" => email,
      "password" => password,
      "password-confirmation" => password_confirmation}}}) do
    
    changeset = User.changeset %User{}, %{email: email,
      password_confirmation: password_confirmation,
      password: password}
    
    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Peep.Web.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peep.Web.ChangesetView, "error.json-api", changeset: changeset)
    end
  
  end
end