defmodule InstaDownloaderTest do
  use ExUnit.Case, async: true
  doctest InstaDownloader

  setup_all do
    image_path =
      Path.join(File.cwd!(), "images")
      |> Path.join("instagram.jpg")

    on_exit(fn ->
      File.rm(image_path)
    end)

    [image_path: image_path]
  end

  test "assert downloader returns :ok" do
    assert InstaDownloader.get_profile_picture("ultr4nerd") == :ok
  end

  test "assert downloaded image in images", context do
    InstaDownloader.get_profile_picture("instagram")
    assert File.exists?(context[:image_path])
  end
end
