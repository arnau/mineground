defmodule Mineground.Game do
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
end
