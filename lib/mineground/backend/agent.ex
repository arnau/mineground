defmodule Mineground.Backend.Worker do
  @moduledoc false

  use Agent
  alias Mineground.Backend.Field

  @doc false
  def start_link(opts)  do
    Agent.start_link(fn -> Field.make(opts[:dimensions], opts[:density]) end, name: __MODULE__)
  end

  def stop do
    Agent.stop(__MODULE__)
  end

  def get do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def update(coord) do
    Agent.update(__MODULE__, fn
      ({:ok, state}) -> Field.unseal(state, coord)
      (res) -> res
    end)
  end
end
