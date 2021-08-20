defmodule Day3 do
  @spec main() :: :ok
  def main do
    with input_stream <- parse_input(),
         part_2_triangles <- part_2(input_stream) do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 3\n**********************\n",
        "Part 1: ",
        "#{Enum.count(input_stream, &valid_triangle?/1)}",
        "\nPart 2: ",
        "#{Enum.count(part_2_triangles, &valid_triangle?/1)}",
        "\n"
      ])
    end
  end

  @spec parse_input() :: Enumerable.t()
  defp parse_input do
    File.read!("day_3_input.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(~r/\s+(\d+)\s+(\d+)\s+(\d+)/, &1))
    |> Stream.map(fn [_, x, y, z] ->
      {String.to_integer(x), String.to_integer(y), String.to_integer(z)}
    end)
  end

  @spec part_2(Enumerable.t()) :: list({integer, integer, integer})
  defp part_2(input_stream) do
    Enum.reduce(
      input_stream,
      %{count: 1, t1: [], t2: [], t3: [], done: []},
      fn {x, y, z}, acc ->
        if acc.count == 3 do
          [side_1, side_2] = acc.t1
          [side_3, side_4] = acc.t2
          [side_5, side_6] = acc.t3
          triangles = [{side_1, side_2, x}, {side_3, side_4, y}, {side_5, side_6, z}]
          %{count: 1, t1: [], t2: [], t3: [], done: triangles ++ acc.done}
        else
          acc
          |> Map.update!(:count, &(&1 + 1))
          |> Map.update!(:t1, &[x | &1])
          |> Map.update!(:t2, &[y | &1])
          |> Map.update!(:t3, &[z | &1])
        end
      end
    )
    |> Map.fetch!(:done)
  end

  @spec valid_triangle?({integer, integer, integer}) :: boolean
  defp valid_triangle?({x, y, z}) do
    case Enum.max([x, y, z]) do
      ^x -> y + z > x
      ^y -> x + z > y
      ^z -> x + y > z
    end
  end
end

Day3.main()
