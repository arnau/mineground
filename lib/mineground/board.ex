defmodule Mineground.Board do
  alias Mineground.Row

  def to_string(board) do
    board
    |> Enum.sort_by(fn (cell) -> Map.get(cell, "row") end)
    |> Enum.chunk_by(fn (cell) -> Map.get(cell, "row") end)
    |> Enum.map(&Row.to_string/1)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
