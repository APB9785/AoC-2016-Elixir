defmodule Day23 do
  @registers ["a", "b", "c", "d"]

  @type state :: map
  @type param :: binary | integer

  @spec main() :: :ok
  def main do
    with f <- File.read!("day_23_input.txt"),
         input <- parse_input(f) do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 23\n",
        "***********************\n",
        "Part 1: ",
        "#{init_state(input, 7) |> run()}",
        "\nPart 2: ",
        "#{init_state(input, 12) |> run()}",
        "\n"
      ])
    end
  end

  @spec parse_input(binary) :: map
  def parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Stream.map(fn {line, idx} -> {idx, parse_line(line)} end)
    |> Map.new()
    |> optimize()
  end

  @spec optimize(map) :: map
  def optimize(commands) do
    commands
    |> Map.put(4, {"multiply"})
    |> Map.put(5, {"noop"})
    |> Map.put(6, {"noop"})
    |> Map.put(7, {"noop"})
    |> Map.put(8, {"noop"})
    |> Map.put(9, {"noop"})
  end

  @spec parse_line(binary) :: tuple
  def parse_line(line) do
    case String.split(line, " ") do
      [command, x] -> {command, parse_param(x)}
      [command, x, y] -> {command, parse_param(x), parse_param(y)}
    end
  end

  @spec parse_param(binary) :: param
  def parse_param(x) when x in @registers, do: x
  def parse_param(x), do: String.to_integer(x)

  @spec init_state(map, integer) :: state
  def init_state(commands, init_val) do
    %{
      registers: %{"a" => init_val, "b" => 0, "c" => 0, "d" => 0},
      index: 0,
      commands: commands
    }
  end

  @spec run(state) :: integer
  def run(state) do
    case Map.get(state.commands, state.index) do
      nil ->
        # End condition
        state.registers["a"]

      {"cpy", x, y} ->
        state
        |> copy(x, y)
        |> Map.update!(:index, &(&1 + 1))
        |> run()

      {"inc", x} ->
        state
        |> Map.update!(:registers, &inc_register(&1, x))
        |> Map.update!(:index, &(&1 + 1))
        |> run()

      {"dec", x} ->
        state
        |> Map.update!(:registers, &dec_register(&1, x))
        |> Map.update!(:index, &(&1 + 1))
        |> run()

      {"jnz", x, y} ->
        state
        |> jump(x, y)
        |> run()

      {"tgl", x} ->
        state
        |> toggle(x)
        |> Map.update!(:index, &(&1 + 1))
        |> run()

      {"multiply"} ->
        prod = get_value(state, "d") * get_value(state, "b")

        state
        |> Map.update!(:registers, fn reg -> Map.update!(reg, "a", &(&1 + prod)) end)
        |> Map.update!(:registers, &Map.put(&1, "d", 0))
        |> Map.update!(:registers, &Map.put(&1, "c", 0))
        |> Map.update!(:index, &(&1 + 6))
        |> run()
    end
  end

  @spec copy(state, param, param) :: state
  def copy(state, _, y) when is_integer(y), do: state

  def copy(state, x, y) do
    Map.update!(state, :registers, &Map.put(&1, y, get_value(state, x)))
  end

  @spec toggle(state, param) :: state
  def toggle(state, x) do
    target = state.index + get_value(state, x)

    case Map.get(state.commands, target) do
      nil -> state
      {"inc", x} -> Map.update!(state, :commands, &Map.put(&1, target, {"dec", x}))
      {_, x} -> Map.update!(state, :commands, &Map.put(&1, target, {"inc", x}))
      {"jnz", x, y} -> Map.update!(state, :commands, &Map.put(&1, target, {"cpy", x, y}))
      {_, x, y} -> Map.update!(state, :commands, &Map.put(&1, target, {"jnz", x, y}))
    end
  end

  @spec jump(state, param, param) :: state
  def jump(state, x, y) do
    if get_value(state, x) == 0 do
      Map.update!(state, :index, &(&1 + 1))
    else
      Map.update!(state, :index, &(&1 + get_value(state, y)))
    end
  end

  @spec inc_register(map, binary) :: map
  def inc_register(registers, key), do: Map.update!(registers, key, &(&1 + 1))

  @spec dec_register(map, binary) :: map
  def dec_register(registers, key), do: Map.update!(registers, key, &(&1 - 1))

  @spec get_value(state, param) :: integer
  def get_value(_state, n) when is_integer(n), do: n
  def get_value(state, n), do: Map.fetch!(state.registers, n)
end

Day23.main()
