defmodule Day15 do
  @spec main() :: :ok
  def main do
    with input <- parse_input(),
         input_2 <- Map.put(input, 7, {11, 0}),
         inf_range <- Stream.iterate(0, &(&1 + 1)) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 15\n",
        "***********************"
      ])

      IO.puts([
        "Part 1: ",
        "#{Enum.find(inf_range, &all_discs_ok?(&1, input))}"
      ])

      IO.puts([
        "Part 2: ",
        "#{Enum.find(inf_range, &all_discs_ok?(&1, input_2))}",
        "\n"
      ])
    end
  end

  @spec parse_input() :: map
  def parse_input do
    p = ~r/Disc #(\d) has (\d+) positions; at time=0, it is at position (\d+)\./
    f = File.read!("day_15_input.txt")

    Regex.scan(p, f)
    |> Stream.map(&tl/1)
    |> Stream.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Enum.reduce(%{}, fn [d, t, s], acc ->
      Map.put(acc, d, {t, s})
    end)
  end

  @spec all_discs_ok?(integer, map) :: boolean
  def all_discs_ok?(time, discs) do
    Enum.all?(1..7, &disc_ok?(&1, time, discs))
  end

  @spec disc_ok?(integer, integer, map) :: boolean
  def disc_ok?(disc, time, discs) do
    case Map.get(discs, disc) do
      nil -> true
      {total, start} -> rem(start + disc + time, total) == 0
    end
  end
end

Day15.main()
