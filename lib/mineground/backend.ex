defmodule Mineground.Backend.Field do
  alias Mineground.Backend.Cell

  @type index :: non_neg_integer
  @type coord :: {non_neg_integer, non_neg_integer}
  @type dimensions :: {non_neg_integer, non_neg_integer}
  @type t :: %{required(coord) => Cell.t}


  @doc """
  Creates a new minefield of {n, m} with an x amount of bombs.

      iex> alias Mineground.Backend.Field
      ...> alias Mineground.Backend.Cell
      ...> Field.make_base({3, 3}, 2) |> Enum.filter(&Cell.is_bomb/1) |> length
      2

      iex> alias Mineground.Backend.Field
      ...> Field.make_base({3, 3}, 2) |> length
      9
  """
  @spec make(dimensions, non_neg_integer) :: t
  def make(dimensions, density) do
    dimensions
    |> make_base(density)
    |> Enum.shuffle()
    |> Enum.with_index()
    |> Map.new(fn ({cell, index}) -> {to_coord(index, dimensions), cell} end)
    |> count_bombs()
  end

  @doc """
      iex> alias Mineground.Backend.Field
      ...> alias Mineground.Backend.Cell
      ...> Field.make_base({3, 3}, 2) |> Enum.filter(&Cell.is_bomb/1) |> length
      2

      iex> alias Mineground.Backend.Field
      ...> Field.make_base({3, 3}, 2) |> length
      9
  """
  @spec make_base(dimensions, non_neg_integer) :: list(Cell.t)
  def make_base({n, m}, density) when density < (n * m) and n == m do
    bombs = List.duplicate(Cell.make(:bomb), density)
    cells = List.duplicate(Cell.make(:empty), (n * m) - density)

    (bombs ++ cells)
  end

  @doc """
  Translates from {index, size} to 2d coordinate.

      iex> alias Mineground.Backend.Field
      ...> Field.to_coord(0, {3, 3})
      {0, 0}

      iex> alias Mineground.Backend.Field
      ...> Field.to_coord(3, {3, 3})
      {1, 0}

      iex> alias Mineground.Backend.Field
      ...> Field.to_coord(7, {3, 3})
      {2, 1}

      iex> alias Mineground.Backend.Field
      ...> Field.to_coord(8, {3, 3})
      {2, 2}

      iex> alias Mineground.Backend.Field
      ...> Enum.map(0..3, &Field.to_coord(&1, {2, 2}))
      [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

      iex> alias Mineground.Backend.Field
      ...> Enum.map(0..11, &Field.to_coord(&1, {4, 3}))
      [{0, 0}, {0, 1}, {0, 2}, {0, 3},
       {1, 0}, {1, 1}, {1, 2}, {1, 3},
       {2, 0}, {2, 1}, {2, 2}, {2, 3}]

      iex> alias Mineground.Backend.Field
      ...> Enum.map(0..11, &Field.to_coord(&1, {2, 6}))
      [{0, 0}, {0, 1},
       {1, 0}, {1, 1},
       {2, 0}, {2, 1},
       {3, 0}, {3, 1},
       {4, 0}, {4, 1},
       {5, 0}, {5, 1}]
  """
  @spec to_coord(index, dimensions) :: coord
  def to_coord(index, {n, _}) do
    {div(index, n), rem(index, n)}
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
  @spec count_bombs(t) :: t
  def count_bombs(grid) do
    grid
    |> Enum.map(fn ({coord, cell}) ->
      {coord, Map.put(cell, :neighbourhood_count, count_bombs_for_coord(grid, coord))}
    end)
    |> Map.new()
  end

  @spec update(t, coord, Cell.t) :: t
  def update(grid, coord, cell) do
    Map.put(grid, coord, cell)
  end

  @doc """
      iex> alias Mineground.Backend.Field
      ...> alias Mineground.Backend.Cell
      ...> Field.unseal(%{{0, 0} => Cell.make(:empty)}, {0, 0})
      %{{0, 0} => %Mineground.Backend.Cell{is_bomb: false, is_visible: true}}
  """
  @spec unseal(t, coord) :: t
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
