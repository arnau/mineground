defmodule MinegroundTest do
  use ExUnit.Case

  doctest Mineground.Cell
  doctest Mineground.Row
  doctest Mineground.Backend.Field
  doctest Mineground.Backend.Cell


  alias Mineground.Backend.Field
  alias Mineground.Backend.Cell

  test "unseal_neighbours all" do
    {:ok, field} = Field.make({4, 4}, 0)

    actual = field
    |> Field.unseal_neighbours({1, 1})
    |> Enum.map(fn {c, _} -> c end)

    assert actual == [
      {{0, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
    ] |> Enum.map(fn {c, _} -> c end)
  end

  test "unseal_neighbours all 5x5" do
    {:ok, field} = Field.make({5, 5}, 0)

    actual = field
    |> Field.unseal_neighbours({1, 1})
    |> Map.to_list()

    assert actual == [
      {{0, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{0, 4}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{1, 4}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{2, 4}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{3, 4}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{4, 0}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{4, 1}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{4, 2}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{4, 3}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
      {{4, 4}, %Cell{is_bomb: false, is_visible: true, neighbourhood_count: 0}},
    ]
  end

  test "unseal_neighbours {20x20, 2}" do
    {:ok, field} = Field.make({20, 20}, 2)

    actual = field
    |> Field.unseal_neighbours({1, 1})
    |> Enum.filter(fn ({_, %{is_visible: visible}}) -> visible end)

    assert actual |> length == 398
  end
end
