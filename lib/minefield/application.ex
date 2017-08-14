defmodule Minefield.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    config = Application.get_env(:mineground, Minefield)
    port = Keyword.get(config, :port)

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: MyApp.Worker.start_link(arg)
      # {MyApp.Worker, arg},
      # Mineground.Backend.Worker.start_link({20, 20}, 10),
      {Mineground.Backend.Worker, [dimensions: {20, 20}, density: 10]},
      Plug.Adapters.Cowboy.child_spec(:http, Minefield.Router, [], [port: port])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Minefield.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
