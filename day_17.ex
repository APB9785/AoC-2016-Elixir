defmodule Day17 do
  @salt "gdjjyniy"

  @type states :: MapSet.t(map)

  @spec main() :: :ok
  def main do
    with init_state <- MapSet.new([%{x: 0, y: 0, path: ""}]) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 17\n",
        "***********************\n",
        "Part 1: ",
        shortest_path(init_state),
        "\nPart 2: ",
        "#{longest_path(init_state)}",
        "\n"
      ])
    end
  end

  @spec shortest_path(states) :: binary
  def shortest_path(states) do
    done = Enum.filter(states, &(&1.x == 3 and &1.y == 3))

    if done == [] do
      states
      |> next_gen()
      |> shortest_path()
    else
      hd(done) |> Map.fetch!(:path)
    end
  end

  @spec longest_path(states) :: integer
  def longest_path(states, max_path \\ 0) do
    if MapSet.size(states) == 0 do
      max_path
    else
      next = next_gen(states)
      {done, todo} = Enum.split_with(next, &(&1.x == 3 and &1.y == 3))
      lengths = Enum.map(done, &String.length(&1.path))

      longest_path(MapSet.new(todo), Enum.max([max_path | lengths]))
    end
  end

  @spec next_gen(states) :: states
  def next_gen(states) do
    Enum.reduce(states, MapSet.new(), fn s, acc ->
      doors = next_doors(s)
      next = Enum.map(doors, &move(s, &1))
      MapSet.union(acc, MapSet.new(next))
    end)
  end

  @spec move(map, binary) :: map
  def move(state, direction) do
    case direction do
      "U" -> state |> Map.update!(:y, &(&1 - 1)) |> Map.update!(:path, &(&1 <> "U"))
      "D" -> state |> Map.update!(:y, &(&1 + 1)) |> Map.update!(:path, &(&1 <> "D"))
      "L" -> state |> Map.update!(:x, &(&1 - 1)) |> Map.update!(:path, &(&1 <> "L"))
      "R" -> state |> Map.update!(:x, &(&1 + 1)) |> Map.update!(:path, &(&1 <> "R"))
    end
  end

  @spec next_doors(map) :: MapSet.t(binary)
  def next_doors(state) do
    open = open_doors(state.path)
    possible = possible_doors(state.x, state.y)
    MapSet.intersection(open, possible)
  end

  @spec possible_doors(integer, integer) :: MapSet.t(binary)
  def possible_doors(x, y) do
    ["U", "D", "L", "R"]
    |> Enum.filter(&(&1 != "U" or y > 0))
    |> Enum.filter(&(&1 != "D" or y < 3))
    |> Enum.filter(&(&1 != "L" or x > 0))
    |> Enum.filter(&(&1 != "R" or x < 3))
    |> MapSet.new()
  end

  @spec open_doors(binary) :: MapSet.t(binary)
  def open_doors(input) do
    :crypto.hash(:md5, @salt <> input)
    |> Base.encode16(case: :lower)
    |> String.slice(0, 4)
    |> String.graphemes()
    |> Enum.zip(["U", "D", "L", "R"])
    |> Enum.map(fn {char, direction} ->
      if char in ["b", "c", "d", "e", "f"], do: direction, else: nil
    end)
    |> Enum.filter(&(&1 != nil))
    |> MapSet.new()
  end
end

Day17.main()
