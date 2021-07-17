defmodule Day9 do
  @spec main() :: :ok
  def main do
    with input <- parse_input() do
      IO.puts(input)
    end
  end

  @spec parse_input() :: binary()
  def parse_input do
    File.read!("day_9_input.txt") |> String.replace([" ", "\n"], "")
  end
end

Day9.main()
