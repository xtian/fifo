defmodule Fifo.Native do
  use Rustler, otp_app: :fifo, crate: :fifo_native

  def open_readonly(_path), do: error()
  def open_writeonly(_path), do: error()

  defp error do
    :erlang.nif_error(:nif_not_loaded)
  end
end
