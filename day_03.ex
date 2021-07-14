defmodule Day3 do
  def main do
    with input_stream <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 3\n**********************\n",
        "Part 1: ",
        "#{Enum.count(input_stream, &valid_triangle?/1)}",
        "\nPart 2: ???",
        "\n"
      ])
    end
  end

  defp parse_input do
    File.read!("day_3_input.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(~r/\s+(\d+)\s+(\d+)\s+(\d+)/, &1))
    |> Stream.map(fn [_, x, y, z] ->
      {String.to_integer(x), String.to_integer(y), String.to_integer(z)}
    end)
  end

  defp valid_triangle?({x, y, z}) do
    case Enum.max([x, y, z]) do
      ^x -> y + z > x
      ^y -> x + z > y
      ^z -> x + y > z
    end
  end
end

Day3.main()
