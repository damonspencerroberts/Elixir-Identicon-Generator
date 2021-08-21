defmodule IdentTest do
  use ExUnit.Case
  doctest Ident

  test "greets the world" do
    assert Ident.hello() == :world
  end
end
