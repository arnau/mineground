defmodule Mineclient do
  @moduledoc """
  Documentation for Mineclient.
  """

  defmodule Board do
    alias Mineclient.Row

    def to_string(board) do
      board
      |> Enum.sort_by(fn (cell) -> Map.get(cell, "row") end)
      |> Enum.chunk_by(fn (cell) -> Map.get(cell, "row") end)
      |> Enum.map(&Row.to_string/1)
      |> Enum.join("\n")
      |> Kernel.<>("\n")
    end
  end

  defmodule Row do
    alias Mineclient.Cell

    @doc """
        iex> alias Mineclient.Row
        ...> [%{"neighbourhood_count" => nil, "column" => 1},
        ...>  %{"neighbourhood_count" => nil, "column" => 2},
        ...>  %{"neighbourhood_count" => 0, "column" => 0}]
        ...> |> Row.to_string()
        ".**"
    """
    def to_string(row) do
      row
      |> Enum.sort_by(fn (cell) -> Map.get(cell, "column") end)
      |> Enum.map(&Cell.to_string/1)
      |> Enum.join()
    end
  end

  defmodule Cell do
    @doc """
    Returns the string representation of a cell.

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"neighbourhood_count" => nil})
        "*"

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"neighbourhood_count" => 0})
        "."

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"neighbourhood_count" => 3})
        "3"

        iex> alias Mineclient.Cell
        ...> Cell.to_string(%{"neighbourhood_count" => 1})
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
