defmodule MessageBird do
  @moduledoc """
  Interacts with the MessageBird API to send SMS messages.
  """
  require Logger

  @spec send_message(phone_number :: String.t, message :: String.t) ::
    {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()} |
    {:error, HTTPoison.Error.t()}
  def send_message(phone_number, message) do
    url = "https://rest.messagebird.com/messages"
    headers = [{"Authorization", "AccessKey #{access_key()}"}]
    body = %{
      recipients: phone_number,
      originator: originator(),
      body: message
    }
    encoded_body = Poison.encode!(body)

    case enabled() do
      true -> HTTPoison.post(url, encoded_body, headers)
      _ ->
        Logger.info("Sending to #{phone_number}: #{message}")
        {:ok, message}
    end
  end

  defp access_key, do: Application.get_env(:camp_with_dennis, :message_bird_access_key)
  defp enabled, do: Application.get_env(:camp_with_dennis, :sms_enabled)
  defp originator, do: Application.get_env(:camp_with_dennis, :default_phone_number)
end
