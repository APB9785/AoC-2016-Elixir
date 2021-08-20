defmodule Day1 do
  @init_state %{
    direction: "N",
    x_coord: 0,
    y_coord: 0,
    seen: MapSet.new([{0, 0}]),
    hq_loc: nil
  }
  @type state :: map

  @spec main() :: :ok
  def main do
    with input <- parse_input(),
         state <- run(@init_state, input),
         distance_travelled <- abs(state.x_coord) + abs(state.y_coord),
         {hq_x, hq_y} <- state.hq_loc,
         hq_distance <- abs(hq_x) + abs(hq_y) do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 1\n**********************\n",
        "Part 1: ",
        Integer.to_string(distance_travelled),
        "\nPart 2: ",
        Integer.to_string(hq_distance),
        "\n"
      ])
    end
  end

  @spec parse_input() :: list(binary)
  defp parse_input do
    File.read!("day_1_input.txt")
    |> String.trim()
    |> String.split(", ")
  end

  @spec run(state, list(binary)) :: state
  defp run(state, []), do: state

  defp run(state, [command | rest]) do
    with {direction, steps_str} <- String.split_at(command, 1),
         steps <- String.to_integer(steps_str) do
      state
      |> turn(direction)
      |> move(steps)
      |> run(rest)
    end
  end

  @spec turn(state, binary) :: state
  defp turn(state, direction) do
    Map.update!(state, :direction, fn
      "N" -> if direction == "L", do: "W", else: "E"
      "S" -> if direction == "L", do: "E", else: "W"
      "E" -> if direction == "L", do: "N", else: "S"
      "W" -> if direction == "L", do: "S", else: "N"
    end)
  end

  @spec move(state, integer) :: state
  defp move(state, 0), do: state

  defp move(state, steps) do
    case state.direction do
      "N" -> Map.update!(state, :y_coord, &(&1 + 1))
      "S" -> Map.update!(state, :y_coord, &(&1 - 1))
      "E" -> Map.update!(state, :x_coord, &(&1 + 1))
      "W" -> Map.update!(state, :x_coord, &(&1 - 1))
    end
    |> check_seen()
    |> move(steps - 1)
  end

  @spec check_seen(state) :: state
  defp check_seen(state) do
    current_location = {state.x_coord, state.y_coord}

    if is_nil(state.hq_loc) and current_location in state.seen do
      Map.put(state, :hq_loc, current_location)
    else
      Map.update!(state, :seen, &MapSet.put(&1, current_location))
    end
  end
end

Day1.main()
