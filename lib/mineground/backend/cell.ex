defmodule Mineground.Backend.Cell do
  @moduledoc """
  Represents a cell in the minefield backend.
  """

  defstruct [:neighbourhood_count, is_bomb: false, is_visible: false]
  @type t :: %__MODULE__{neighbourhood_count: integer,
                         is_visible: boolean,
                         is_bomb: boolean}


  @doc """
  Creates a new cell of the provided type `:empty | :bomb`.

      iex> alias Mineground.Backend.Cell
      ...> Cell.make(:empty)
      %Mineground.Backend.Cell{is_bomb: false, is_visible: false}

      iex> alias Mineground.Backend.Cell
      ...> Cell.make(:bomb)
      %Mineground.Backend.Cell{is_bomb: true, is_visible: false}
  """
  @spec make(atom) :: t
  def make(:empty) do
    %__MODULE__{is_bomb: false}
  end

  def make(:bomb) do
    %__MODULE__{is_bomb: true}
  end

  @spec unseal(t) :: t
  def unseal(cell) do
    Map.put(cell, :is_visible, true)
  end

  @spec is_bomb(t) :: boolean
  def is_bomb(%__MODULE__{is_bomb: value}), do: value

  @spec is_visible(t) :: boolean
  def is_visible(%__MODULE__{is_visible: value}), do: value

  @spec is_unsealable(t) :: boolean
  def is_unsealable(%__MODULE__{is_bomb: is_bomb, is_visible: is_visible}) do
    !is_bomb && !is_visible
  end

  @spec has_neighbours(t) :: boolean
  def has_neighbours(%__MODULE__{neighbourhood_count: count}) do
    count > 0
  end
end
