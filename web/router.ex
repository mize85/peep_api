defmodule Peep.Router do
  use Peep.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Peep do
    pipe_through :api

    # Registration
    post "register", RegistrationController, :create

    # Route stuff to our SessionController
    resources "session", SessionController, only: [:index]

    # Login
    post "token", SessionController, :create, as: :login

  end

  scope "/api", Peepchat do
      pipe_through :api_auth
      get "/user/current", UserController, :current
    end

end


