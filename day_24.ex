defmodule Day24 do
  @moduledoc """
  First we parse the input grid into a Map for coord lookup in constant time.

  Then calculate and store the distances from each landmark to each other
  landmark, using breadth-first search.

  Then since the number of landmarks is not large (n < 10), we can apply a
  brute-force approach to the Traveling Salesman Problem, summing the distances
  for each possible route and keeping the lowest.

  Runs in about 5s on my machine, most of which is spent on BFS to
  pre-calculate the distances.
  """
  @type coord :: {integer, integer}

  @spec main() :: :ok
  def main do
    with f <- File.read!("day_24_input.txt"),
         {walls, landmarks} <- parse_input(f),
         all_distances <- map_distances(landmarks, walls),
         destinations <- Map.keys(landmarks) -- [0] do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 24\n",
        "***********************\n",
        "Part 1: ",
        "#{shortest_trip(destinations, all_distances, return: false)}",
        "\nPart 2: ",
        "#{shortest_trip(destinations, all_distances, return: true)}",
        "\n"
      ])
    end
  end

  @spec parse_input(binary) :: {MapSet.t(coord), map}
  def parse_input(txt) do
    list = String.graphemes(txt)
    parse_input(list, {0, 0}, MapSet.new(), %{})
  end

  defp parse_input([], _, walls, landmarks), do: {walls, landmarks}

  defp parse_input([h | t], {x, y}, walls, landmarks) do
    case h do
      "#" -> parse_input(t, {x + 1, y}, MapSet.put(walls, {x, y}), landmarks)
      "." -> parse_input(t, {x + 1, y}, walls, landmarks)
      "\n" -> parse_input(t, {0, y + 1}, walls, landmarks)
      n -> parse_input(t, {x + 1, y}, walls, Map.put(landmarks, String.to_integer(n), {x, y}))
    end
  end

  @spec shortest_trip(list(integer), map, return: boolean) :: integer
  def shortest_trip(destinations, distances, opts) do
    destinations
    |> permutations()
    |> Stream.map(fn p ->
      if Keyword.get(opts, :return), do: [0 | p] ++ [0], else: [0 | p]
    end)
    |> Stream.map(&trip_distance(&1, distances))
    |> Enum.min()
  end

  @spec trip_distance(list(integer), map) :: integer
  def trip_distance(trip, distance_map) do
    trip
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(&sort_list_to_tuple/1)
    |> Stream.map(&Map.fetch!(distance_map, &1))
    |> Enum.sum()
  end

  defp sort_list_to_tuple(list) do
    list
    |> Enum.sort()
    |> List.to_tuple()
  end

  @spec map_distances(map, MapSet.t(coord)) :: map
  def map_distances(landmarks, walls) do
    map_distances(landmarks, walls, 0, 1, %{})
  end

  defp map_distances(landmarks, _, x, _, done)
       when map_size(landmarks) - 1 == x do
    done
  end

  defp map_distances(landmarks, walls, x, y, done)
       when map_size(landmarks) == y do
    map_distances(landmarks, walls, x + 1, x + 2, done)
  end

  defp map_distances(landmarks, walls, x, y, done) do
    d = distance(landmarks[x], landmarks[y], walls)
    map_distances(landmarks, walls, x, y + 1, Map.put(done, {x, y}, d))
  end

  @spec distance(coord, coord, MapSet.t(coord)) :: integer
  def distance(start_coord, destination, walls) do
    distance([start_coord], MapSet.new(), 0, destination, walls)
  end

  defp distance([], seen, count, destination, walls) do
    distance(MapSet.to_list(seen), MapSet.new(), count + 1, destination, walls)
  end

  defp distance([h | _t], _, count, destination, _) when h == destination do
    count
  end

  defp distance([h | t], seen, count, destination, walls) do
    new_seen = MapSet.union(possible_moves(h, walls), seen)
    distance(t, new_seen, count, destination, walls)
  end

  @spec possible_moves(coord, MapSet.t(coord)) :: MapSet.t(coord)
  def possible_moves({x, y}, walls) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.reject(&MapSet.member?(walls, &1))
    |> MapSet.new()
  end

  defp permutations([]), do: [[]]

  defp permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end

Day24.main()
