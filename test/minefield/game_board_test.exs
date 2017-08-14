defmodule Minefield.BoardTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Minefield.Router.init([])

  test "returns hello world" do
    conn = conn(:get, "/board")
    conn = Minefield.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body |> Poison.decode!() |> length() == 400
  end

  test "successfully moves" do
    conn = conn(:post, "/move", Poison.encode!(%{row: 0, column: 0}))
           |> put_req_header("content-type", "application/json")
    conn = Minefield.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body |> Poison.decode!() |> length() == 400
  end
end
