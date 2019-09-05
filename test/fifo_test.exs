defmodule FifoTest do
  use ExUnit.Case
  doctest Fifo

  test "greets the world" do
    assert Fifo.hello() == :world
  end
end
