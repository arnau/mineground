defmodule Mineground.Row do
  alias Mineground.Cell

  @doc """
      iex> alias Mineground.Row
      ...> [%{"neighbourhood_count" => nil, "column" => 1},
      ...>  %{"neighbourhood_count" => nil, "column" => 2},
      ...>  %{"neighbourhood_count" => 0, "column" => 0}]
      ...> |> Row.to_string()
      ".**"
  """
  def to_string(row) do
    row
    |> Enum.sort_by(fn (cell) -> Map.get(cell, "column") end)
    |> Enum.map(&Cell.to_string/1)
    |> Enum.join()
  end
end
