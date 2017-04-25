defmodule Peep.Web.User do
  use Peep.Web, :model
  use Arc.Ecto.Schema

  schema "users" do
    field :email, :string
    field :password_hash, :string

    # Two virtual fields for password confirmation
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    field :avatar, Peep.Web.Avatar.Type


    has_many :messages, Peep.Web.Message
    has_many :rooms, Peep.Web.Room

    timestamps()
  end

  @required_fields ~w(email password password_confirmation)
  @optional_fields ~w()

   @required_file_fields ~w()
   @optional_file_fields ~w(avatar)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
    def changeset(model, params \\ :empty) do
      model
      |> cast(params, @required_fields, @optional_fields)
      |> cast_attachments(params, @required_file_fields, @optional_file_fields)
      |> validate_format(:email, ~r/@/)
      |> validate_length(:password, min: 8)
      |> validate_confirmation(:password)
      |> hash_password
      |> unique_constraint(:email)
    end

  def changeset_update(model, params \\ :empty) do
        IO.inspect(model)
        IO.inspect(params)
        model
        |> cast_attachments(params, [:avatar])
        |> validate_format(:email, ~r/@/)
        |> unique_constraint(:email)
      end



  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
      hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
      Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end

end
