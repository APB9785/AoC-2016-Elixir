defmodule Day21 do
  @type state() :: [{binary(), integer()}]

  @state_size 8

  @spec main() :: :ok
  def main do
    with f <- File.read!("day_21_input.txt"),
         input <- parse_input(f),
         init_state <- init_state() do
      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 21\n",
        "***********************\n",
        "Part 1: ",
        run_commands(input, init_state)
      ])

      unscrambled =
        init_state
        |> permutations()
        |> Enum.find(fn pass -> run_commands(input, pass) == "fbgdceah" end)

      IO.puts(["Part 2: ", unscrambled, "\n"])
    end
  end

  def parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  def init_state do
    "abcdefghijklmnopqrstuvwxyz"
    |> String.graphemes()
    |> Enum.take(@state_size)
  end

  def run_commands(commands, state) do
    commands
    |> Enum.reduce(Enum.with_index(state), &run_command/2)
    |> to_list()
    |> Enum.join()
  end

  def run_command(command, state) do
    case command do
      ["rotate", "based" | rest] -> rotate_based(rest, state)
      ["rotate" | rest] -> rotate(rest, state)
      ["swap", "position" | rest] -> swap_position(rest, state)
      ["swap", "letter" | rest] -> swap_letter(rest, state)
      ["reverse", "positions" | rest] -> reverse_positions(rest, state)
      ["move", "position" | rest] -> move_position(rest, state)
    end
  end

  def swap_position([x, "with", "position", y], state) do
    [x, y] = Enum.map([x, y], &String.to_integer/1)

    Enum.map(state, fn el ->
      case el do
        {char, ^x} -> {char, y}
        {char, ^y} -> {char, x}
        {char, idx} -> {char, idx}
      end
    end)
  end

  def swap_letter([x, "with", "letter", y], state) do
    Enum.map(state, fn el ->
      case el do
        {^x, idx} -> {y, idx}
        {^y, idx} -> {x, idx}
        {char, idx} -> {char, idx}
      end
    end)
  end

  def rotate([direction, n, _], state) do
    n = String.to_integer(n)

    Enum.map(state, fn {char, idx} ->
      case direction do
        "left" -> {char, Integer.mod(idx - n, @state_size)}
        "right" -> {char, Integer.mod(idx + n, @state_size)}
      end
    end)
  end

  def rotate_based(["on", "position", "of", "letter", x], state) do
    case to_list(state) do
      [^x, a, b, c, d, e, f, g] -> [g, x, a, b, c, d, e, f]
      [a, ^x, b, c, d, e, f, g] -> [f, g, a, x, b, c, d, e]
      [a, b, ^x, c, d, e, f, g] -> [e, f, g, a, b, x, c, d]
      [a, b, c, ^x, d, e, f, g] -> [d, e, f, g, a, b, c, x]
      [a, b, c, d, ^x, e, f, g] -> [c, d, x, e, f, g, a, b]
      [a, b, c, d, e, ^x, f, g] -> [b, c, d, e, x, f, g, a]
      [a, b, c, d, e, f, ^x, g] -> [a, b, c, d, e, f, x, g]
      [a, b, c, d, e, f, g, ^x] -> [x, a, b, c, d, e, f, g]
    end
    |> Enum.with_index()
  end

  def reverse_positions([x, "through", y], state) do
    [x, y] = Enum.map([x, y], &String.to_integer/1)
    l = to_list(state)
    {front, rest} = Enum.split(l, x)
    {middle, back} = Enum.split(rest, y - x + 1)

    [front, Enum.reverse(middle), back]
    |> Enum.concat()
    |> Enum.with_index()
  end

  def move_position([x, "to", "position", y], state) when x < y do
    [x, y] = Enum.map([x, y], &String.to_integer/1)

    Enum.map(state, fn {char, idx} ->
      cond do
        idx < x or idx > y ->
          {char, idx}

        idx == x ->
          {char, y}

        true ->
          {char, idx - 1}
      end
    end)
  end

  def move_position([x, "to", "position", y], state) when x > y do
    [x, y] = Enum.map([x, y], &String.to_integer/1)

    Enum.map(state, fn {char, idx} ->
      cond do
        idx > x or idx < y ->
          {char, idx}

        idx == x ->
          {char, y}

        true ->
          {char, idx + 1}
      end
    end)
  end

  def to_list(state) do
    state
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.map(&elem(&1, 0))
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end

Day21.main()
