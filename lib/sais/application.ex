defmodule Sais.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SaisWeb.Telemetry,
      Sais.Repo,
      {DNSCluster, query: Application.get_env(:sais, :dns_cluster_query) || :ignore},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:sais, :ash_domains),
         Application.fetch_env!(:sais, Oban)
       )},
      # Start the Finch HTTP client for sending emails
      # Start a worker by calling: Sais.Worker.start_link(arg)
      # {Sais.Worker, arg},
      # Start to serve requests, typically the last entry
      {Phoenix.PubSub, name: Sais.PubSub},
      {Finch, name: Sais.Finch},
      SaisWeb.Endpoint,
      {Absinthe.Subscription, SaisWeb.Endpoint},
      AshGraphql.Subscription.Batcher,
      {AshAuthentication.Supervisor, [otp_app: :sais]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sais.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SaisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
