defmodule ExSMTPTest do
  use ExUnit.Case
  doctest ExSMTP

  test "greets the world" do
    assert ExSMTP.hello() == :world
  end
end
