defmodule Day13 do
  @input 1364
  @start {1, 1}
  @destination {31, 39}
  @max_steps 50

  @type coord :: {integer, integer}

  require Integer

  @spec main() :: :ok
  def main do
    with part_1 <- steps_to_destination(),
         part_2 <- Enum.count(reachable_coords()) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 13\n",
        "***********************\n",
        "Part 1: ",
        Integer.to_string(part_1),
        "\nPart 2: ",
        Integer.to_string(part_2),
        "\n"
      ])
    end
  end

  @spec steps_to_destination() :: integer
  def steps_to_destination do
    steps_to_destination(MapSet.new([@start]), 0)
  end

  defp steps_to_destination(paths, count) do
    if MapSet.member?(paths, @destination) do
      count
    else
      next_paths = Enum.reduce(paths, MapSet.new(), &MapSet.union(&2, possible_moves(&1)))
      steps_to_destination(next_paths, count + 1)
    end
  end

  @spec reachable_coords() :: MapSet.t(coord)
  def reachable_coords do
    reachable_coords(MapSet.new([@start]), 0)
  end

  defp reachable_coords(paths, steps_taken) do
    if steps_taken == @max_steps do
      paths
    else
      next_paths = Enum.reduce(paths, paths, &MapSet.union(&2, possible_moves(&1)))
      reachable_coords(next_paths, steps_taken + 1)
    end
  end

  @spec possible_moves(coord) :: list(coord)
  def possible_moves({x, y}) do
    neighbors = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

    Enum.filter(neighbors, &valid_coord?/1)
    |> MapSet.new()
  end

  @spec valid_coord?(coord) :: boolean
  def valid_coord?({x, y}) when x < 0 or y < 0, do: false

  def valid_coord?({x, y}) do
    val = x * x + 3 * x + 2 * x * y + y + y * y + @input

    Integer.to_string(val, 2)
    |> String.graphemes()
    |> Enum.count(&(&1 == "1"))
    |> Integer.is_even()
  end
end

Day13.main()
