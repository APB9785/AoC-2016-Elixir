defmodule Day7 do
  @brackets ["[", "]"]

  @type state :: map

  @spec main() :: :ok
  def main do
    with input <- parse_input() do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 7\n**********************",
        "\nPart 1: ",
        check_all(input, :tls),
        "\nPart 2: ",
        check_all(input, :ssl),
        "\n"
      ])
    end
  end

  @spec parse_input() :: list(binary)
  def parse_input do
    File.read!("day_7_input.txt")
    |> String.split("\n", trim: true)
  end

  @spec check_all(list(binary), atom) :: binary
  def check_all(input, :tls) do
    input
    |> Stream.map(&check_line_tls/1)
    |> Enum.count(&(&1.found_outside and not &1.found_inside))
    |> Integer.to_string()
  end

  def check_all(input, :ssl) do
    input
    |> Stream.map(&check_line_ssl/1)
    |> Enum.count(&compare_matches/1)
    |> Integer.to_string()
  end

  ## PART 1 - TLS

  @spec check_line_tls(binary) :: state
  def check_line_tls(line) do
    parse_tls(%{
      todo: String.graphemes(line),
      inside_now: false,
      found_outside: false,
      found_inside: false
    })
  end

  @spec parse_tls(state) :: state
  def parse_tls(%{todo: [a, b, b, a]} = state)
      when a != b and a not in @brackets and b not in @brackets do
    Map.put(state, :found_outside, true)
  end

  def parse_tls(%{todo: [_, _, _, _]} = state), do: state

  def parse_tls(%{todo: [a, b, b, a | _]} = state)
      when a != b and a not in @brackets and b not in @brackets do
    if state.inside_now do
      state |> Map.update!(:todo, &tl/1) |> Map.put(:found_inside, true) |> parse_tls()
    else
      state |> Map.update!(:todo, &tl/1) |> Map.put(:found_outside, true) |> parse_tls()
    end
  end

  def parse_tls(%{todo: [_, _, _, "[" | _]} = state) do
    state |> Map.update!(:todo, &tl/1) |> Map.put(:inside_now, true) |> parse_tls()
  end

  def parse_tls(%{todo: [_, _, _, "]" | _]} = state) do
    state |> Map.update!(:todo, &tl/1) |> Map.put(:inside_now, false) |> parse_tls()
  end

  def parse_tls(state), do: state |> Map.update!(:todo, &tl/1) |> parse_tls()

  ## PART 2 - SSL

  @spec check_line_ssl(binary) :: state
  def check_line_ssl(line) do
    parse_ssl(%{
      todo: String.graphemes(line),
      inside_now: false,
      found_outside: [],
      found_inside: []
    })
  end

  @spec parse_ssl(state) :: state
  def parse_ssl(%{todo: [a, b, a]} = state)
      when a != b and a not in @brackets and b not in @brackets do
    Map.update!(state, :found_outside, &[Enum.join([a, b, a]) | &1])
  end

  def parse_ssl(%{todo: [_, _, _]} = state), do: state

  def parse_ssl(%{todo: [a, b, a | _]} = state)
      when a != b and a not in @brackets and b not in @brackets do
    if state.inside_now do
      state
      |> Map.update!(:todo, &tl/1)
      |> Map.update!(:found_inside, &[Enum.join([a, b, a]) | &1])
      |> parse_ssl()
    else
      state
      |> Map.update!(:todo, &tl/1)
      |> Map.update!(:found_outside, &[Enum.join([a, b, a]) | &1])
      |> parse_ssl()
    end
  end

  def parse_ssl(%{todo: [_, _, "[" | _]} = state) do
    state |> Map.update!(:todo, &tl/1) |> Map.put(:inside_now, true) |> parse_ssl()
  end

  def parse_ssl(%{todo: [_, _, "]" | _]} = state) do
    state |> Map.update!(:todo, &tl/1) |> Map.put(:inside_now, false) |> parse_ssl()
  end

  def parse_ssl(state), do: state |> Map.update!(:todo, &tl/1) |> parse_ssl()

  @spec compare_matches(Enumerable.t()) :: boolean
  def compare_matches(state) do
    Enum.reduce_while(state.found_inside, false, fn bab, _acc ->
      if invert(bab) in state.found_outside do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  @spec invert(binary) :: binary
  defp invert(input) do
    with [a, b, a] <- String.graphemes(input) do
      Enum.join([b, a, b])
    end
  end
end

Day7.main()
