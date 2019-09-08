defmodule FifoTest do
  use ExUnit.Case

  @filename "test_fifo"

  setup do
    {_, 0} = System.cmd("mkfifo", [@filename])

    on_exit(fn ->
      {_, 0} = System.cmd("rm", ["-rf", @filename])
    end)

    :ok
  end

  defp fifo_write(value) do
    {_, 0} = System.cmd("/bin/sh", ["-c", "echo #{value} > #{@filename}"])
  end

  describe "stream/2" do
    test "writes bytes from FIFO to stream" do
      test_pid = self()

      spawn(fn ->
        assert {:ok, stream} = Fifo.stream(@filename)
        for value <- stream, do: send(test_pid, {:value, value})
      end)

      value = Enum.take_random(?a..?z, 1)
      fifo_write(value)

      byte = Enum.at(value, 0)
      assert_receive {:value, ^byte}
    end

    test "writes binaries from FIFO to stream" do
      test_pid = self()

      spawn(fn ->
        assert {:ok, stream} = Fifo.stream(@filename, [:binary])
        for value <- stream, do: send(test_pid, {:value, value})
      end)

      values = for _ <- 0..1, do: :rand.uniform()

      for value <- values, do: fifo_write(value)

      for value <- values do
        value = "#{value}\n"
        assert_receive {:value, ^value}
      end
    end

    test "returns error for non-existent file" do
      assert {:error, _} = Fifo.stream("#{:rand.uniform()}")
    end
  end

  describe "stream!/2" do
    test "returns stream" do
      test_pid = self()

      spawn(fn ->
        assert :ok = @filename |> Fifo.stream!() |> Stream.take(1) |> Stream.run()
        send(test_pid, :ok)
      end)

      fifo_write("#{:rand.uniform()}")
      assert_receive :ok
    end

    test "raises error for non-existent file" do
      assert_raise Fifo.FifoError, fn ->
        Fifo.stream!("#{:rand.uniform()}")
      end
    end
  end
end
