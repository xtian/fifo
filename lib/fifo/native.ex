defmodule Fifo.Native do
  @moduledoc false

  use Rustler, otp_app: :fifo, crate: :fifo_native

  def open_file_readonly(_path), do: error()
  def open_file_writeonly(_path), do: error()

  defp error do
    :erlang.nif_error(:nif_not_loaded)
  end
end
