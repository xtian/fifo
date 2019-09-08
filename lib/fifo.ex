defmodule Fifo do
  @moduledoc false

  defmodule FifoError do
    defexception [:description, :errno]

    def message(error) do
      errno = if error.errno, do: "(errno: #{error.errno})"
      "#{error.description} #{errno}"
    end
  end

  @spec stream(String.t()) :: {:ok, Enum.t()} | {:error, %FifoError{}}
  def stream(filename, options \\ []) do
    with {:ok, fd} <- Fifo.Native.open_file_readonly(filename) do
      stream =
        Stream.resource(
          fn -> open_in_port(fd, options) end,
          fn port ->
            receive do
              {_, {:data, data}} when is_list(data) -> {data, port}
              {_, {:data, data}} when is_binary(data) -> {[data], port}
              {_, :connected} -> {[], port}
              {_, :closed} -> {:halt, port}
              {:EXIT, _, _} -> {:halt, port}
            end
          end,
          &Port.close/1
        )

      {:ok, stream}
    end
  end

  @spec stream!(String.t()) :: Enum.t() | no_return
  def stream!(filename, options \\ []) do
    case stream(filename, options) do
      {:ok, stream} -> stream
      {:error, error} -> raise FifoError, description: error.description, errno: error.errno
    end
  end

  defp open_in_port(fd, options) do
    port = Port.open({:fd, fd, fd}, [:in | options])
    _ = Port.monitor(port)

    port
  end
end
