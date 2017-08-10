defmodule Mineclient do
  @moduledoc """
  Documentation for Mineclient.
  """

  alias Mineclient.Cell

  def to_string(board) do
    board
    |> Enum.chunk_by(fn (cell) -> Map.get(cell, "row") end)
    |> Enum.map(fn (row) ->
      row
      |> Enum.map(&Cell.to_string/1)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defmodule Cell do
    @doc """
    Returns the string representation of a cell.

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"visible" => false})
        "*"

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"visible" => true, "neighbourhood_count" => 0})
        "."

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"visible" => true, "neighbourhood_count" => 3})
        "3"

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"visible" => true, "neighbourhood_count" => 1})
        "1"
    """
    def to_string(cell) do
      cell
      |> Map.get("neighbourhood_count")
      |> (fn (nil) -> "*"
             (0)   -> "."
             (x)   -> Integer.to_string(x)
      end).()
    end
  end
end
