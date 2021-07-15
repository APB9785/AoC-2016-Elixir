defmodule Day5 do
  @input "wtnhxymk"

  @spec main() :: :ok
  def main do
    with input_stream <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 5\n**********************",
        "\nPart 1: ",
        part_1(input_stream),
        "\nPart 2: ",
        part_2(input_stream),
        "\n"
      ])
    end
  end

  @spec parse_input() :: Enumerable.t()
  def parse_input do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(fn i -> [@input, Integer.to_string(i)] end)
    |> Stream.map(&:crypto.hash(:md5, &1))
    |> Stream.map(&Base.encode16(&1, case: :lower))
    |> Stream.filter(&String.starts_with?(&1, "00000"))
  end

  @spec part_1(Enumerable.t()) :: binary()
  def part_1(input_stream) do
    input_stream
    |> Stream.take(8)
    |> Stream.map(&String.at(&1, 5))
    |> Enum.join()
  end

  @spec part_2(Enumerable.t()) :: binary()
  def part_2(input_stream) do
    empty_password_map = Enum.reduce(0..7, %{}, &Map.put(&2, "#{&1}", nil))

    Enum.reduce_while(
      input_stream,
      empty_password_map,
      fn s, acc ->
        if Enum.any?(Map.values(acc), &is_nil/1) do
          [pos, val] = s |> String.slice(5..6) |> String.graphemes()
          {:cont, Map.update(acc, pos, "x", &if(is_nil(&1), do: val, else: &1))}
        else
          {:halt, acc}
        end
      end
    )
    |> then(&[&1["0"], &1["1"], &1["2"], &1["3"], &1["4"], &1["5"], &1["6"], &1["7"]])
    |> Enum.join()
  end
end

Day5.main()
