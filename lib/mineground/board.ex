defmodule Mineground.Board do
  alias Mineground.Row
  alias Mineground.Api
  alias Mineground.Board

  def move(row, column) do
    with {:ok, %{"status" => status}} <- Api.move(row, column),
         {:ok, board} <- Api.board() do

      board = Board.to_string(board)

      case status do
        "in_progress" -> board
        "success" -> "#{board}\n\nYou won!"
        "failure" -> "#{board}\n\nYou lost."
      end
    end
  end

  def to_string(board) do
    board
    |> Enum.sort_by(fn (cell) -> Map.get(cell, "row") end)
    |> Enum.chunk_by(fn (cell) -> Map.get(cell, "row") end)
    |> Enum.map(&Row.to_string/1)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end
end
