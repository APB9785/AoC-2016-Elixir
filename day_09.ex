defmodule Day9 do
  @spec main() :: :ok
  def main do
    with input <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 9\n**********************",
        "\nPart 1: ",
        "#{count(input, 1)}",
        "\nPart 2: ",
        "#{count(input, 2)}",
        "\n"
      ])
    end
  end

  @spec parse_input() :: list(binary())
  def parse_input do
    File.read!("day_9_input.txt") |> String.graphemes() |> Enum.reject(&(&1 in [" ", "\n"]))
  end

  @spec count(list(binary()), integer(), integer()) :: integer()
  def count(todo, version, n \\ 0)

  def count([], _, n), do: n

  def count(["(" | t], version, n) do
    {inside, [")" | outside]} = Enum.split_while(t, &(&1 != ")"))
    {a, ["x" | b]} = Enum.split_while(inside, &(&1 != "x"))
    [a, b] = [a, b] |> Stream.map(&Enum.join/1) |> Enum.map(&String.to_integer/1)

    case version do
      1 ->
        count(Enum.drop(outside, a), version, a * b + n)

      2 ->
        {curr, rest} = Enum.split(outside, a)
        decompressed_length = count(curr, version) * b
        count(rest, version, n + decompressed_length)
    end
  end

  def count([_ | t], version, n), do: count(t, version, n + 1)
end

Day9.main()
