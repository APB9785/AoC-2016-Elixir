defmodule Day8 do
  @x_range 0..49
  @max_x 50
  @y_range 0..5
  @max_y 6

  @type state :: map

  @spec main() :: :ok
  def main do
    with input <- parse_input(),
         final_state <- Enum.reduce(input, make_state(), &run_command/2) do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 8\n**********************",
        "\nPart 1: ",
        "#{Enum.count(final_state, &elem(&1, 1))}",
        "\nPart 2: ",
        "\n#{display_screen(final_state)}",
        "\n"
      ])
    end
  end

  @spec show_transformations() :: :ok
  def show_transformations do
    with input <- parse_input() do
      final_state =
        Enum.reduce(input, make_state(), fn x, acc ->
          acc
          |> tap(&display_transformations/1)
          |> then(&run_command(x, &1))
        end)

      IO.puts(display_screen(final_state))
    end
  end

  @spec parse_input() :: Enumerable.t()
  def parse_input do
    pattern = ~r/(rect|rotate) (\d+)?x?(\d+)?(?:row |column )?(x|y)?=?(\d+)?(?: by )?(\d+)?/

    File.read!("day_8_input.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(pattern, &1))
    |> Stream.map(&tl/1)
    |> Stream.map(&format_match/1)
  end

  @spec make_state() :: state
  def make_state do
    for x <- @x_range,
        y <- @y_range do
      {{x, y}, false}
    end
    |> Map.new()
  end

  @spec format_match(list) :: tuple
  def format_match(["rect", x, y]) do
    {:rect, String.to_integer(x), String.to_integer(y)}
  end

  def format_match(["rotate", "", "", axis, index, count]) do
    {:rotate, axis, String.to_integer(index), String.to_integer(count)}
  end

  @spec run_command(tuple, state) :: state
  def run_command({:rotate, axis, index, count}, state) do
    Enum.reduce(state, %{}, fn {{x, y}, pixel}, acc ->
      cond do
        axis == "x" and x == index ->
          Map.put(acc, {x, y}, Map.fetch!(state, {x, wrap(y - count, "y")}))

        axis == "y" and y == index ->
          Map.put(acc, {x, y}, Map.fetch!(state, {wrap(x - count, "x"), y}))

        true ->
          Map.put(acc, {x, y}, pixel)
      end
    end)
  end

  def run_command({:rect, x_bound, y_bound}, state) do
    Enum.reduce(state, %{}, fn {{x, y}, pixel}, acc ->
      if x < x_bound and y < y_bound do
        Map.put(acc, {x, y}, true)
      else
        Map.put(acc, {x, y}, pixel)
      end
    end)
  end

  @spec display_screen(state) :: iolist
  def display_screen(state) do
    Enum.reduce(@y_range, [], &display_line(&1, &2, state))
    |> Enum.reverse()
  end

  @spec display_line(integer, iolist, state) :: iolist
  def display_line(y, prev, state) do
    Enum.reduce(@x_range, prev, fn x, acc ->
      if Map.fetch!(state, {x, y}), do: ["█" | acc], else: [" " | acc]
    end)
    |> then(&["\n" | &1])
  end

  @spec display_transformations(state) :: :ok
  def display_transformations(state) do
    Process.sleep(75)

    Enum.reduce(@y_range, [], &display_line(&1, &2, state))
    |> Enum.reverse()
    |> IO.puts()
  end

  @spec wrap(integer, binary) :: integer
  defp wrap(n, "x") when n in @x_range, do: n
  defp wrap(n, "x") when n < 0, do: wrap(@max_x + n, "x")
  defp wrap(n, "x"), do: wrap(n - @max_x, "x")
  defp wrap(n, "y") when n in @y_range, do: n
  defp wrap(n, "y") when n < 0, do: wrap(@max_y + n, "y")
  defp wrap(n, "y"), do: wrap(n - @max_y, "y")
end

# Standard display - comment out the line below if using visual display
Day8.main()

# Uncomment the line below for visual display!
# Day8.show_transformations()
