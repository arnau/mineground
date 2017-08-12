defmodule Mineground.Backend.Field do
  alias Mineground.Backend.Cell

  @doc """
      iex> alias Mineground.Backend.Field
      ...> alias Mineground.Backend.Cell
      ...> Field.make({3, 3}, 2) |> Enum.filter(&Cell.is_bomb/1) |> length
      2

      iex> alias Mineground.Backend.Field
      ...> Field.make({3, 3}, 2) |> length
      9
  """
  def make({n, m}, density) when density < (n * m) and n == m do
    bombs = List.duplicate(%Cell{is_bomb: true}, density)
    cells = List.duplicate(%Cell{is_bomb: false}, (n * m) - density)

    (bombs ++ cells)
  end

  def start(dimensions = {n, _}, density) do
    make(dimensions, density)
    |> Enum.shuffle()
    |> Enum.with_index()
    |> Map.new(fn ({cell, index}) -> {Cell.to_coord(index, n), cell} end)
    |> count_bombs()
  end

  @doc """
      iex> alias Mineground.Backend.Field
      ...> grid = %{{0, 0} => %Mineground.Backend.Cell{is_bomb: true, is_visible: false},
      ...>          {0, 1} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false},
      ...>          {1, 0} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false},
      ...>          {1, 1} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false}}
      ...> Field.count_bombs(grid)
      %{{0, 0} => %Mineground.Backend.Cell{is_bomb: true, is_visible: false, neighbourhood_count: 0},
        {0, 1} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false, neighbourhood_count: 1},
        {1, 0} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false, neighbourhood_count: 1},
        {1, 1} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false, neighbourhood_count: 1}}
  """
  def count_bombs(grid) do
    grid
    |> Enum.map(fn ({coord, cell}) ->
      {coord, Map.put(cell, :neighbourhood_count, count_bombs_for_coord(grid, coord))}
    end)
    |> Map.new()
  end

  def update(grid, coord, cell) do
    Map.put(grid, coord, cell)
  end

  @doc """
      iex> alias Mineground.Backend.Field
      ...> alias Mineground.Backend.Cell
      ...> Field.unseal(%{{0, 0} => Cell.make(:empty)}, {0, 0})
      %{{0, 0} => %Mineground.Backend.Cell{is_bomb: false, is_visible: true}}
  """
  def unseal(grid, coord = {_x, _y}) do
    cell = Cell.unseal(Map.get(grid, coord))
    grid = update(grid, coord, cell)

    if Cell.is_bomb(cell) || Cell.has_neighbours(cell) do
      grid
    else
      unseal_neighbours(grid, coord)
    end
  end

  @doc """
  Recursively unseals all unsealable neighbours given an initial coordinate.
  """
  def unseal_neighbours(grid, coord) do
    cells = neighbour_coords(coord)
    |> Enum.map(fn (coord) -> {coord, Map.get(grid, coord)} end)
    |> Enum.filter(fn ({_, cell}) -> cell && Cell.is_unsealable(cell) end)
    |> Enum.map(fn ({coord, cell}) -> {coord, Cell.unseal(cell)} end)

    Enum.reduce(cells, Map.merge(grid, Map.new(cells)), fn ({coord, _}, acc) ->
      unseal_neighbours(acc, coord)
    end)
  end

  @doc """
      iex> alias Mineground.Backend.Field
      ...> grid = %{{0, 0} => %Mineground.Backend.Cell{is_bomb: true, is_visible: false},
      ...>          {0, 1} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false},
      ...>          {1, 0} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false},
      ...>          {1, 1} => %Mineground.Backend.Cell{is_bomb: false, is_visible: false}}
      ...> Field.count_bombs_for_coord(grid, {1, 1})
      1
  """
  def count_bombs_for_coord(grid, coord) do
    neighbour_coords(coord)
    |> Enum.reduce(0, fn (coord, sum) ->
      cell = Map.get(grid, coord)
      if cell && Cell.is_bomb(cell) do
        sum + 1
      else
        sum
      end
    end)
  end

  def neighbour_coords({x, y}) do
    [{x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1},
     {x    , y - 1},             {x    , y + 1},
     {x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}]
  end
end
