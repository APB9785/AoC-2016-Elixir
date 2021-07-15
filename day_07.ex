defmodule Day7 do
  @brackets ["[", "]"]

  @type state() :: map()

  @spec main() :: :ok
  def main do
    with input <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 7\n**********************",
        "\nPart 1: ",
        part_1(input),
        "\nPart 2: ???",
        "\n"
      ])
    end
  end

  @spec parse_input() :: list(binary())
  def parse_input do
    File.read!("day_7_input.txt")
    |> String.split("\n", trim: true)
  end

  @spec part_1(list(binary())) :: binary()
  def part_1(input) do
    input
    |> Stream.map(&check_line/1)
    |> Enum.count(&(&1.found_outside and not &1.found_inside))
    |> Integer.to_string()
  end

  @spec check_line(binary()) :: state()
  def check_line(line) do
    parse(%{
      todo: String.graphemes(line),
      inside_now: false,
      found_outside: false,
      found_inside: false
    })
  end

  @spec parse(state()) :: state()
  def parse(%{todo: [a, b, b, a]} = state)
      when a != b and a not in @brackets and b not in @brackets do
    Map.put(state, :found_outside, true)
  end

  def parse(%{todo: [_, _, _, _]} = state), do: state

  def parse(%{todo: [a, b, b, a | _]} = state)
      when a != b and a not in @brackets and b not in @brackets do
    if state.inside_now do
      state |> Map.update!(:todo, &tl/1) |> Map.put(:found_inside, true) |> parse()
    else
      state |> Map.update!(:todo, &tl/1) |> Map.put(:found_outside, true) |> parse()
    end
  end

  def parse(%{todo: [_, _, _, "[" | _]} = state) do
    state |> Map.update!(:todo, &tl/1) |> Map.put(:inside_now, true) |> parse()
  end

  def parse(%{todo: [_, _, _, "]" | _]} = state) do
    state |> Map.update!(:todo, &tl/1) |> Map.put(:inside_now, false) |> parse()
  end

  def parse(state), do: state |> Map.update!(:todo, &tl/1) |> parse()
end

Day7.main()
