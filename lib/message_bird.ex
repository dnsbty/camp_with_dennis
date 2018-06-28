defmodule MessageBird do
  @moduledoc """
  Interacts with the MessageBird API to send SMS messages.
  """
  require Logger

  @spec send_message(recipients :: String.t :: list(String.t), message :: String.t) ::
    {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()} |
    {:error, HTTPoison.Error.t()}
  def send_message(recipients, message) when is_list(recipients) do
    results = Enum.map(recipients, &send_message(&1, message))
    failures = Enum.filter(results, &parse_result/1)
    case length(failures) do
      0 -> Logger.info("Successfully sent to #{length(results)} recipients")
      count -> Logger.info("Failed to send to #{count} recipients: #{inspect(failures)}")
    end
  end
  def send_message(recipients, message) do
    url = "https://rest.messagebird.com/messages"
    headers = [{"Authorization", "AccessKey #{access_key()}"}]
    body = %{
      recipients: recipients,
      originator: originator(),
      body: message
    }
    encoded_body = Poison.encode!(body)

    case enabled() do
      true -> HTTPoison.post(url, encoded_body, headers)
      _ ->
        log_message(recipients, message)
        {:ok, message}
    end
  end

  defp log_message(recipients, message) when is_list(recipients) do
    recipient_count = length(recipients)
    Logger.info("Sending to #{recipient_count} recipients: #{message}")
  end
  defp log_message(recipients, message) do
    Logger.info("Sending to #{recipients}: #{message}")
  end

  defp parse_result({:ok, %HTTPoison.Response{status_code: 201}}), do: false
  defp parse_result(error), do: error

  defp access_key, do: Application.get_env(:camp_with_dennis, :message_bird_access_key)
  defp enabled, do: Application.get_env(:camp_with_dennis, :sms_enabled)
  defp originator, do: Application.get_env(:camp_with_dennis, :default_phone_number)
end
