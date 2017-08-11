defmodule Mineground.ApiTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mineground.Api

  test "fetch board" do
    use_cassette "initial board state" do
      assert {:ok, _} = Api.board()
    end
  end

  test "move once" do
    use_cassette "move 0 13 state" do
      assert {:ok, _} = Api.move(0, 13)
    end
  end

  test "move once and fetch" do
    use_cassette "move 0 13 and board state" do
      assert {:ok, _} = Api.move(0, 13)
      assert {:ok, _} = Api.board()
    end
  end

end
