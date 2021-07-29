defmodule Day12 do
  @pattern ~r/(\w+) (\w+) ?([\w-]+)?/
  @registers ["a", "b", "c", "d"]
  @start_1 %{"a" => 0, "b" => 0, "c" => 0, "d" => 0}
  @start_2 %{"a" => 0, "b" => 0, "c" => 1, "d" => 0}

  @type state() :: map()

  @spec main() :: :ok
  def main do
    with input <- parse_input(),
         state_1 <- run_commands(input, [], @start_1),
         state_2 <- run_commands(input, [], @start_2) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 12\n",
        "***********************\n",
        "Part 1: ",
        Integer.to_string(state_1["a"]),
        "\nPart 2: ",
        Integer.to_string(state_2["a"]),
        "\n"
      ])
    end
  end

  @spec parse_input() :: list(binary())
  def parse_input do
    f = File.read!("day_12_input.txt")

    Regex.scan(@pattern, f)
    |> Enum.map(&tl/1)
  end

  @spec run_commands(list(), list(), state()) :: state()
  def run_commands(todo, done, state)

  def run_commands([], _, state), do: state

  def run_commands([["cpy", p1, p2] | rest], done, state) do
    val = get_value(p1, state)

    run_commands(rest, [["cpy", p1, p2] | done], Map.put(state, p2, val))
  end

  def run_commands([["jnz", p1, p2] | rest], done, state) do
    offset = String.to_integer(p2)

    cond do
      get_value(p1, state) == 0 ->
        run_commands(rest, [["jnz", p1, p2] | done], state)

      offset < 0 ->
        run_commands(
          Enum.reverse(Enum.take(done, 0 - offset)) ++ [["jnz", p1, p2] | rest],
          Enum.drop(done, 0 - offset),
          state
        )

      offset > 0 ->
        run_commands(
          Enum.drop([["jnz", p1, p2] | rest], offset),
          Enum.reverse(Enum.take([["jnz", p1, p2] | rest], offset)) ++ done,
          state
        )
    end
  end

  def run_commands([["inc", key] | rest], done, state) do
    run_commands(
      rest,
      [["inc", key] | done],
      Map.update!(state, key, &(&1 + 1))
    )
  end

  def run_commands([["dec", key] | rest], done, state) do
    run_commands(
      rest,
      [["dec", key] | done],
      Map.update!(state, key, &(&1 - 1))
    )
  end

  @spec get_value(binary(), state()) :: integer()
  defp get_value(key_or_value, state) do
    if key_or_value in @registers do
      Map.fetch!(state, key_or_value)
    else
      String.to_integer(key_or_value)
    end
  end
end

Day12.main()
