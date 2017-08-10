defmodule Mineground.Cell do
  @doc """
  Returns the string representation of a cell.

  iex> alias Mineground.Cell
  ...> Cell.to_string(%{"neighbourhood_count" => nil})
  "*"

  iex> alias Mineground.Cell
  ...> Cell.to_string(%{"neighbourhood_count" => 0})
  "."

  iex> alias Mineground.Cell
  ...> Cell.to_string(%{"neighbourhood_count" => 3})
  "3"

  iex> alias Mineground.Cell
  ...> Cell.to_string(%{"neighbourhood_count" => 1})
  "1"
  """
  def to_string(cell) do
    cell
    |> Map.get("neighbourhood_count")
    |> (fn (nil) -> "*"
      (0)   -> "."
      (x)   -> Integer.to_string(x)
    end).()
  end
end
