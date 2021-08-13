defmodule Day20 do
  @type blacklist() :: list(Range.t())

  @spec main() :: :ok
  def main do
    with f <- File.read!("day_20_input.txt"),
         input <- parse_input(f) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 20\n",
        "***********************\n",
        "Part 1: ",
        "#{lowest_outside(input)}",
        "\nPart 2: ",
        "#{total_allowed(input)}",
        "\n"
      ])
    end
  end

  @spec parse_input(binary()) :: blacklist()
  def parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Stream.map(&text_to_range/1)
    |> Enum.sort_by(fn range -> range.first end)
  end

  @spec text_to_range(binary()) :: Range.t()
  def text_to_range(line) do
    [lo, hi] = String.split(line, "-")
    Range.new(String.to_integer(lo), String.to_integer(hi))
  end

  @spec lowest_outside(blacklist()) :: integer()
  def lowest_outside(blacklist) do
    lowest_outside(blacklist, 0)
  end

  defp lowest_outside([h | t], idx) do
    if h.first > idx do
      idx
    else
      lowest_outside(t, h.last + 1)
    end
  end

  @spec total_allowed(blacklist()) :: integer()
  def total_allowed(blacklist) do
    total_allowed(blacklist, 0, 0)
  end

  defp total_allowed([], count, _), do: count

  defp total_allowed([h | t], count, idx) do
    cond do
      h.last < idx ->
        total_allowed(t, count, idx)

      h.first > idx ->
        allowed = h.first - idx
        total_allowed(t, count + allowed, h.last + 1)

      true ->
        total_allowed(t, count, h.last + 1)
    end
  end
end

Day20.main()
