defmodule Peep.Router do
  use Peep.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", Peep do
    pipe_through :api
    # Route stuff to our SessionController
    resources "session", SessionController, only: [:index]
  end





end


