defmodule MineclientTest do
  use ExUnit.Case
  doctest Mineclient

  test "initial state" do
    raw =
      File.read!("test/initial_state.json")
      |> Poison.decode!()

    actual = Mineclient.parse(raw)
    expected = """
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             ********************
             """

    assert actual == expected
  end

  test "After {0, 13} move" do
    raw =
      File.read!("test/move_0_13_state.json")
      |> Poison.decode!()

    actual = Mineclient.parse(raw)
    expected = """
            ....................
            ....................
            ....................
            ....................
            ....................
            ....................
            .........111......11
            .........1*1......1*
            .........111......1*
            .................11*
            .111...111.......1**
            .1*1...1*1.......1**
            .111...111......11**
            ................1***
            ................12**
            11...........111.111
            *1...........1*1....
            *2...........111....
            *1..................
            *1..................
            """

    assert actual == expected
  end

  test "query an existing cell" do
    board =
      File.read!("test/move_0_13_state.json")
      |> Poison.decode!()

    assert Mineclient.get_cell(board, {2, 5}) ==  %{"column" => 5, "neighbourhood_count" => 0, "row" => 2, "visible" => true}
  end
end
