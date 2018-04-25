defmodule MessageBird do
  @moduledoc """
  Interacts with the MessageBird API to send SMS messages.
  """

  @originator "+12016227284"

  @spec send_message(phone_number :: String.t, message :: String.t) ::
    {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()} |
    {:error, HTTPoison.Error.t()}
  def send_message(phone_number, message) do
    url = "https://rest.messagebird.com/messages"
    headers = [{"Authorization", "AccessKey #{access_key()}"}]
    body = %{
      recipients: phone_number,
      originator: @originator,
      body: message
    }
    encoded_body = Poison.encode!(body)

    HTTPoison.post(url, encoded_body, headers)
  end

  defp access_key, do: Application.get_env(:camp_with_dennis, :message_bird_access_key)
end
