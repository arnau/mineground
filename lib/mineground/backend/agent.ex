defmodule Mineground.Backend.Agent do
  alias Mineground.Backend.Field

  @doc false
  def start_link(dimensions \\ {20, 20}, density \\ 10)  do
    Agent.start_link(fn -> Field.start(dimensions, density) end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def update(coord) do
    Agent.update(__MODULE__, &Field.unseal(&1, coord))
  end
end
