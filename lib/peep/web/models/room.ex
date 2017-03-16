defmodule Peep.Web.Room do
  use Peep.Web, :model

  schema "rooms" do
    field :name, :string
    belongs_to :owner, Peep.Web.User
    has_many :messages, Peep.Web.Message, on_delete: :delete_all
    
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
