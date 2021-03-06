defmodule Peep.Web.Router do
  use Peep.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api", "multipart"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    #plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", Peep.Web do
    pipe_through :api

    # Registration
    post "/register", RegistrationController, :create

    # Route stuff to our SessionController
    resources "/session", SessionController, only: [:index]

    # Login
    post "/token", SessionController, :create, as: :login

  end

  scope "/api", Peep.Web do
     pipe_through :api_auth
     get "/user/current", UserController, :current

     resources "/user", UserController, only: [:show, :index] do
        get "/rooms", RoomController, :index, as: :rooms
        get "/messages", MessageController, :index, as: :messages
     end

     resources "/users", UserController, only: [:show, :index, :update]

     resources "/messages", MessageController, only: [:index, :show, :update, :delete, :create]
     resources "/rooms", RoomController, except: [:new, :edit] do
        get "/messages", MessageController, :index, as: :messages
        post "/messages", MessageController, :create, as: :messages
     end
  end

end


