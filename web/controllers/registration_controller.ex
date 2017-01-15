defmodule Peep.RegistrationController do
  use Peep.Web, :controller

  alias Peep.User

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
        |> render(Peep.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peep.ChangesetView, "error.json-api", changeset: changeset)
    end
  
  end
end