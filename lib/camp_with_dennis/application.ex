defmodule CampWithDennis.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    case Application.get_env(:camp_with_dennis, :environment) do
      :test -> nil
      _ -> SmsVerification.start()
    end

    children = [
      supervisor(CampWithDennis.Repo, []),
      supervisor(CampWithDennisWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: CampWithDennis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    CampWithDennisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
