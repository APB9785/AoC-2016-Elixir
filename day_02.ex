defmodule Day2 do
  def main do
    with input <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 2\n**********************\n",
        "Part 1: ",
        part_1(input),
        "\nPart 2: ???\n"
      ])
    end
  end

  def parse_input do
    File.read!("day_2_input.txt")
    |> String.graphemes()
  end

  def part_1(todo, current \\ 5, done \\ [])

  def part_1([], _, done), do: done |> Enum.reverse() |> Enum.join()

  def part_1([h | t], current, done) do
    case h do
      "\n" -> part_1(t, current, [Integer.to_string(current) | done])
      direction -> part_1(t, move(current, direction), done)
    end
  end

  def move(current, direction) do
    case direction do
      "U" -> if current <= 3, do: current, else: current - 3
      "D" -> if current > 6, do: current, else: current + 3
      "L" -> if current in [1, 4, 7], do: current, else: current - 1
      "R" -> if current in [3, 6, 9], do: current, else: current + 1
    end
  end
end

Day2.main()
