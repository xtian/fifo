# Fifo

Modern utilities for working with Unix named pipes (FIFOs)

## Installation

Add `fifo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fifo, "~> 0.1.0"}
  ]
end
```

## Usage

You can operate on a stream of bytes:

```elixir
"path/to/fifo"
|> Fifo.stream!()
|> Enum.each(fn byte -> do_something(byte) end)
```

Or you can opt to receive a stream of binaries:

```elixir
"path/to/fifo"
|> Fifo.stream!([:binary])
|> Enum.each(fn binary -> do_something(binary) end)
```

