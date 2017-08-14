defmodule Minefield.Game do
  @moduledoc false

  import Plug.Conn
  alias Mineground.Backend.Worker
  alias Mineground.Backend.Field

  @doc """
  Returns the current board regardless of the status.
  """
  def board(conn) do
    {_ok, board} = Worker.get()
    board = Field.to_list(board)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(board))
  end

  def move(conn) do
    coord = coord_from_payload(conn.body_params)
    Worker.update(coord)
    {_ok, board} = Worker.get()
    board = Field.to_list(board)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(board))
  end

  defp coord_from_payload(%{"row" => row, "column" => column}) do
    {row, column}
  end
end
