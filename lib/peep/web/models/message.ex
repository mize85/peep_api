defmodule Peep.Web.Message do
  use Peep.Web, :model
  
    schema "messages" do
      field :body, :string
      belongs_to :author, Peep.Web.User
      belongs_to :room, Peep.Web.Room
  
      timestamps()
    end
  

    def changeset(model, params \\ :empty) do
      model
      |> cast(params, [:body, :author_id, :room_id])
      |> validate_required([:body, :author_id, :room_id])
      |> validate_length(:body, min: 1) # Body is 1+ characters
      |> assoc_constraint(:author) # Author exists
      |> assoc_constraint(:room) # Room exists
    end
end
