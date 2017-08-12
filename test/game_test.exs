defmodule Mineground.GameTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mineground.Game

  test "move once" do
    use_cassette "game move 0 0" do
      assert Game.move(0, 0)
    end
  end
end
