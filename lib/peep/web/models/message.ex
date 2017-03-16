defmodule Peep.Web.Message do
  use Peep.Web, :model
  
    schema "messages" do
      field :body, :string
      belongs_to :author, Peep.Web.User
      belongs_to :room, Peep.Web.Room
  
      timestamps()
    end
  
    @required_fields ~w(body author_id room_id)
    @optional_fields ~w()
  
    def changeset(model, params \\ :empty) do
      model
      |> cast(params, @required_fields, @optional_fields)
      |> validate_length(:body, min: 1) # Body is 1+ characters
      |> assoc_constraint(:author) # Author exists
      |> assoc_constraint(:room) # Room exists
    end
end
