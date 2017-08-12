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

  @doc """
  Translates from {index, size} to 2d coordinate.

      iex> alias Mineground.Backend.Cell
      ...> Cell.to_coord(0, 3)
      {0, 0}

      iex> alias Mineground.Backend.Cell
      ...> Cell.to_coord(3, 3)
      {1, 0}

      iex> alias Mineground.Backend.Cell
      ...> Cell.to_coord(7, 3)
      {2, 1}

      iex> alias Mineground.Backend.Cell
      ...> Cell.to_coord(8, 3)
      {2, 2}

      iex> alias Mineground.Backend.Cell
      ...> Enum.map(0..3, &Cell.to_coord(&1, 2))
      [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  """
  def to_coord(index, size) do
    {div(index, size), rem(index, size)}
  end

  def unseal(cell) do
    Map.put(cell, :is_visible, true)
  end

  def is_bomb(%__MODULE__{is_bomb: value}), do: value
  def is_visible(%__MODULE__{is_visible: value}), do: value

  def is_unsealable(%__MODULE__{is_bomb: is_bomb, is_visible: is_visible}) do
    !is_bomb && !is_visible
  end

  def has_neighbours(%__MODULE__{neighbourhood_count: count}) do
    count > 0
  end
end
