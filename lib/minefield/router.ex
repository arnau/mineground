defmodule Minefield.Router do
  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  alias Minefield.Game

  plug Plug.Logger
  plug Plug.RequestId
  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass: ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/board" do
    Game.board(conn)
  end

  post "/move" do
    Game.move(conn)
  end

  # match _ do
  #   send_resp(conn, 404, "oops")
  # end

  defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    send_resp(conn, conn.status, "Something went wrong")
  end
end
