defmodule Day18 do
  @type state :: MapSet.t(integer)

  @spec main() :: :ok
  def main do
    with input <- File.read!("day_18_input.txt") |> String.trim(),
         init_state <- parse_input(input) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 18\n",
        "***********************"
      ])

      IO.puts(["Part 1: ", "#{count_gens(init_state, 40)}"])
      IO.puts(["Part 2: ", "#{count_gens(init_state, 400_000)}", "\n"])
    end
  end

  @spec parse_input(binary) :: state
  def parse_input(s) do
    s
    |> String.graphemes()
    |> Stream.with_index()
    |> Stream.filter(fn {el, _idx} -> el == "^" end)
    |> Enum.map(&elem(&1, 1))
    |> MapSet.new()
  end

  @spec count_gens(state, integer, integer) :: integer
  def count_gens(state, gens, count \\ 0)
  def count_gens(_, 0, count), do: count

  def count_gens(state, gens, count) do
    count_gens(
      next_gen(state),
      gens - 1,
      count + (100 - MapSet.size(state))
    )
  end

  @spec next_gen(state) :: state
  def next_gen(state) do
    Enum.reduce(0..99, MapSet.new(), fn x, acc ->
      if valid?(state, x), do: MapSet.put(acc, x), else: acc
    end)
  end

  @spec valid?(state, integer) :: boolean
  def valid?(state, idx) do
    left = MapSet.member?(state, idx - 1)
    right = MapSet.member?(state, idx + 1)

    left != right
  end
end

Day18.main()
