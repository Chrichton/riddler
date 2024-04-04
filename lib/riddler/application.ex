defmodule Riddler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RiddlerWeb.Telemetry,
      Riddler.Repo,
      {DNSCluster, query: Application.get_env(:riddler, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Riddler.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Riddler.Finch},
      # Start a worker by calling: Riddler.Worker.start_link(arg)
      # {Riddler.Worker, arg},
      # Start to serve requests, typically the last entry
      RiddlerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Riddler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RiddlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
