defmodule Day16 do
  @input "10010000000110000"

  @type state() :: list(boolean())

  @spec main() :: :ok
  def main do
    with input <- parse_input(@input) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 16\n",
        "***********************"
      ])

      part_1 = input |> extend(272) |> compress(272)
      IO.puts(["Part 1: ", part_1])

      part_2 = input |> extend(35_651_584) |> compress(35_651_584)
      IO.puts(["Part 2: ", part_2, "\n"])
    end
  end

  @spec parse_input(binary()) :: state()
  def parse_input(str) do
    str
    |> String.graphemes()
    |> Enum.map(&(&1 == "1"))
  end

  @spec extend(state(), integer()) :: state()
  def extend(state, end_size) do
    extend(state, end_size, length(state))
  end

  defp extend(state, end_size, current_length) do
    if current_length >= end_size do
      Enum.take(state, end_size)
    else
      new_state = state ++ [false | flip_reverse(state)]
      extend(new_state, end_size, 2 * current_length + 1)
    end
  end

  @spec flip_reverse(state()) :: state()
  defp flip_reverse(state) do
    Stream.map(state, &not/1)
    |> Enum.reverse()
  end

  @spec compress(state(), integer()) :: binary()
  def compress(state, start_size) do
    chunk_size = calculate_chunk_size(start_size)
    chunks = Enum.chunk_every(state, chunk_size)

    Enum.reduce(chunks, [], fn chunk, acc ->
      ones = Enum.count(chunk, & &1)
      if rem(ones, 2) == 0, do: ["1" | acc], else: ["0" | acc]
    end)
    |> Enum.reverse()
  end

  @spec calculate_chunk_size(integer()) :: integer()
  def calculate_chunk_size(len, multiplier \\ 1) do
    if rem(len, 2) == 0 do
      calculate_chunk_size(div(len, 2), multiplier * 2)
    else
      multiplier
    end
  end
end

Day16.main()
