defmodule InstaDownloader do
  @moduledoc """
  Documentation for `InstaDownloader`.
  """

  @doc """
  Get Instagram Profile Picture by username

  ## Examples

      iex> InstaDownloader.get_profile_picture("ultr4nerd")
      :ok
  """
  def get_profile_picture(username) do
    case HTTPoison.get("https://www.instadp.com/fullsize/#{username}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.parse_document!()
        |> Floki.find("a.download-btn")
        |> Floki.attribute("href")
        |> List.first()
        |> download_picture(username)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Username URL not found!")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp download_picture("", _username) do
    IO.puts("Username not found!")
  end

  defp download_picture(url, username) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Path.join(File.cwd!, "images")
        |> Path.join("#{username}.jpg")
        |> File.write(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Download URL not found!")
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
