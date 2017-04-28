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

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
    def changeset(model, params \\ :empty) do
      model
      |> cast(params, [:email, :password, :password_confirmation])
      |> validate_required([:email, :password, :password_confirmation])
      |> cast_attachments(params, [:avatar])
      |> validate_format(:email, ~r/@/)
      |> validate_length(:password, min: 8)
      |> validate_confirmation(:password)
      |> hash_password
      |> unique_constraint(:email)
    end

  def changeset_update(model, params \\ :empty) do
        model
        |> cast(params, [:email])
        |> validate_required(:email)
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
