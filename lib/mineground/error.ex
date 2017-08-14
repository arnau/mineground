defmodule Mineground.Error do
  @moduledoc false

  @type t :: %{errors: list(%{reason: any})}

  @doc """
  Creates a new error from the given reason.
  """
  def make(reason) do
    %{errors: [%{reason: reason}]}
  end
end
