defmodule Day2 do
  @type button :: binary | integer

  @spec main() :: :ok
  def main do
    with input <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 2\n**********************\n",
        "Part 1: ",
        run(input, :simple),
        "\nPart 2: ",
        run(input, :diamond),
        "\n"
      ])
    end
  end

  @spec parse_input() :: list(binary)
  def parse_input do
    File.read!("day_2_input.txt")
    |> String.graphemes()
  end

  @spec run(list(binary), :simple | :diamond, button, list(binary)) :: binary
  def run(todo, pattern, current \\ 5, done \\ [])
  def run([], _, _, done), do: done |> Enum.reverse() |> Enum.join()
  def run(["\n" | t], pattern, current, done), do: run(t, pattern, current, ["#{current}" | done])
  def run([h | t], :simple, current, done), do: run(t, :simple, move_1(current, h), done)
  def run([h | t], :diamond, current, done), do: run(t, :diamond, move_2(current, h), done)

  @spec move_1(integer, binary) :: integer
  def move_1(current, direction) do
    case direction do
      "U" -> if current <= 3, do: current, else: current - 3
      "D" -> if current > 6, do: current, else: current + 3
      "L" -> if current in [1, 4, 7], do: current, else: current - 1
      "R" -> if current in [3, 6, 9], do: current, else: current + 1
    end
  end

  @spec move_2(button, binary) :: button
  def move_2(current, "U") do
    case current do
      x when x in [1, 2, 4, 5, 9] -> x
      x when x in [6, 7, 8] -> x - 4
      3 -> 1
      "A" -> 6
      "B" -> 7
      "C" -> 8
      "D" -> "B"
    end
  end

  def move_2(current, "D") do
    case current do
      x when x in [5, 9, "A", "C", "D"] -> x
      x when x in [2, 3, 4] -> x + 4
      1 -> 3
      6 -> "A"
      7 -> "B"
      8 -> "C"
      "B" -> "D"
    end
  end

  def move_2(current, "L") do
    case current do
      x when x in [1, 2, 5, "A", "D"] -> x
      x when x in [3, 4, 6, 7, 8, 9] -> x - 1
      "B" -> "A"
      "C" -> "B"
    end
  end

  def move_2(current, "R") do
    case current do
      x when x in [1, 4, 9, "C", "D"] -> x
      x when x in [2, 3, 5, 6, 7, 8] -> x + 1
      "A" -> "B"
      "B" -> "C"
    end
  end
end

Day2.main()
