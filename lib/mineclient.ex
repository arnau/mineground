defmodule Mineclient do
  @moduledoc """
  Documentation for Mineclient.
  """


  def parse(board) do
    ((0..19)
    |> Enum.map(fn (row_index) ->
      Enum.map(0..19, fn (column_index) ->
        cell = get_cell(board, {row_index, column_index})

        cell_to_ascii(cell)
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")) <> "\n"
  end


  def get_cell(board, {row_index, column_index}) do
    Enum.find(board, fn (x) ->
      Map.get(x, "column") == column_index && Map.get(x, "row") == row_index
    end)
  end


  def cell_to_ascii(cell) do
    if Map.get(cell, "visible") do
      count = Map.get(cell, "neighbourhood_count")

      if count == 0 do
        "."
      else
        Integer.to_string(count)
      end
    else
      "*"
    end
  end
end
