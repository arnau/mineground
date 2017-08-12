defmodule Mineground.Cell do

  defstruct [row: 0, column: 0, neighbourhood_count: 0, visible: true]
  @type t :: %__MODULE__{row: integer,
                         column: integer,
                         neighbourhood_count: integer,
                         visible: boolean}

  def empty(row, column) do
    %__MODULE__{row: row,
                column: column,
                neighbourhood_count: nil,
                visible: false}
  end

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
