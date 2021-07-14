defmodule Day1 do
  def main do
    input = parse_input()

    {x, y} = part_1(input)

    IO.puts([
      "**********************\n",
      "ADVENT OF CODE - DAY 1",
      "\n**********************\n",
      "Part 1: #{abs(x) + abs(y)}\n",
      "Part 2: ???"
    ])
  end

  def part_1(input) do
    state = run_commands(input)

    {state.x_coord, state.y_coord}
  end

  defp parse_input do
    File.read!("day_1_input.txt")
    |> String.trim()
    |> String.split(", ")
  end

  defp run_commands(command_list) do
    Enum.reduce(command_list, init_state(), fn command, state ->
      [direction | steps] = String.graphemes(command)

      state
      |> turn(direction)
      |> move(steps)
    end)
  end

  defp turn(state, direction) do
    Map.update!(state, :direction, fn
      "N" -> if direction == "L", do: "W", else: "E"
      "S" -> if direction == "L", do: "E", else: "W"
      "E" -> if direction == "L", do: "N", else: "S"
      "W" -> if direction == "L", do: "S", else: "N"
    end)
  end

  defp move(state, step_count) do
    with steps <- step_count |> IO.iodata_to_binary() |> String.to_integer() do
      case state.direction do
        "N" -> Map.update!(state, :y_coord, &(&1 + steps))
        "S" -> Map.update!(state, :y_coord, &(&1 - steps))
        "E" -> Map.update!(state, :x_coord, &(&1 + steps))
        "W" -> Map.update!(state, :x_coord, &(&1 - steps))
      end
    end
  end

  defp init_state do
    %{direction: "N", x_coord: 0, y_coord: 0}
  end
end

Day1.main()
