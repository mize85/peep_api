defmodule Peep.Web.RoomChannel do
  use Peep.Web, :channel
  require Logger
  import Guardian.Phoenix.Socket

  def join("room:" <> room, _payload, socket) do
    user = current_resource(socket)
    if user do
        {:ok, "Hello #{user.email}! Joined Room:#{room}", socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info({:after_join, msg}, socket) do
      broadcast! socket, "user:entered", %{user: msg["user"]}
      push socket, "join", %{status: "connected"}
      {:noreply, socket}
  end

  def terminate(reason, _socket) do
      Logger.debug"> leave #{inspect reason}"
      :ok
  end
end
