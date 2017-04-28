defmodule Peep.Web.Avatar do
  use Arc.Definition
  def __storage, do: Arc.Storage.Local # Add this


  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition


  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Whitelist file extensions:
  def filename(version,  {file, _scope}), do: "#{version}_#{file.file_name}"

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png .bmp .JPG) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150 -format png"}
  end

  # Override the storage directory:
  def storage_dir(_version, {file, scope}) do
    "uploads/user/avatars/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version) do
      "https://placehold.it/250x250"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
