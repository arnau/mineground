defmodule Mineground.Api do
  def board do
    host = Application.get_env(:mineground, :host)
    res = HTTPoison.get!("#{host}/board")
    case res do
      %{status_code: 200, body: body} -> {:ok, Poison.decode!(body)}
      e -> {:error, e}
    end
  end

  def move(row, column) do
    host = Application.get_env(:mineground, :host)
    res = HTTPoison.post!("#{host}/moves",
                          Poison.encode!(%{row: row, column: column}),
                          [{"content-type", "application/json"}])

    case res do
      %{status_code: 200, body: body} -> {:ok, Poison.decode!(body)}
      e -> {:error, e}
    end
  end
end
