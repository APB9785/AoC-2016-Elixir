defmodule Day10 do
  @type chip :: integer
  @type state :: map

  @spec main() :: :ok
  def main do
    with input <- parse_input(),
         final_result <- input |> make_state() |> run() do
      IO.puts(["Part 2: ", "#{final_result}", "\n"])
    end
  end

  @spec parse_input() :: Enumerable.t()
  def parse_input do
    pattern =
      ~r/(?:value )?(?:bot )?(\d+)(?: gives low)?(?: goes)? to (bot|output) (\d+)(?: and high to )?(bot|output)? ?(\d+)?/

    File.read!("day_10_input.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(pattern, &1))
    |> Stream.map(&tl/1)
    |> Stream.map(&format_match/1)
  end

  @spec format_match(list) :: tuple
  def format_match([value, "bot", bot]), do: {String.to_integer(bot), String.to_integer(value)}

  def format_match([bot, type_1, id_1, type_2, id_2]) do
    {String.to_integer(bot), {type_1, String.to_integer(id_1)}, {type_2, String.to_integer(id_2)}}
  end

  @spec make_state(Enumerable.t()) :: state
  def make_state(rules) do
    Enum.reduce(rules, %{}, fn
      {bot, chip}, acc -> add_chip(acc, bot, chip)
      {bot, low, high}, acc -> set_bot_rules(acc, bot, low, high)
    end)
  end

  @spec add_chip(state, integer, integer) :: state
  def add_chip(state, bot, chip) do
    Map.update(state, bot, %{holding: [chip]}, fn this ->
      Map.update!(this, :holding, &[chip | &1])
    end)
  end

  @spec set_bot_rules(state, integer, tuple, tuple) :: state
  def set_bot_rules(state, bot, low, high) do
    Map.update(state, bot, %{holding: [], give_low: low, give_high: high}, fn this ->
      this |> Map.put(:give_low, low) |> Map.put(:give_high, high)
    end)
  end

  @spec run(state) :: integer
  def run(state) do
    Enum.reduce(state, state, fn {bot_id, bot_map}, acc ->
      cond do
        is_binary(bot_id) ->
          # This must be an output
          acc

        length(bot_map.holding) == 2 ->
          [low_chip, high_chip] = Enum.sort(bot_map.holding)
          if low_chip == 17 and high_chip == 61, do: print_header(bot_id)

          acc
          |> Map.update!(bot_id, &Map.put(&1, :holding, []))
          |> give_chip(low_chip, bot_map.give_low)
          |> give_chip(high_chip, bot_map.give_high)

        true ->
          acc
      end
    end)
    |> then(
      &if(all_outputs_present?(&1),
        do: Enum.reduce(0..2, 1, fn x, acc -> acc * hd(Map.get(&1, "output-#{x}")) end),
        else: run(&1)
      )
    )
  end

  @spec all_outputs_present?(state) :: list(integer) | nil
  def all_outputs_present?(state) do
    state["output-0"] && state["output-1"] && state["output-2"]
  end

  @spec give_chip(state, integer, {binary, integer}) :: state
  def give_chip(state, chip, {"output", id}) do
    Map.update(state, "output-#{id}", [chip], &[chip | &1])
  end

  def give_chip(state, chip, {"bot", id}) do
    Map.update!(state, id, fn this ->
      Map.update!(this, :holding, &[chip | &1])
    end)
  end

  @spec print_header(integer) :: :ok
  defp print_header(bot_id) do
    IO.puts([
      "***********************\nADVENT OF CODE - DAY 10\n***********************",
      "\nPart 1: ",
      Integer.to_string(bot_id)
    ])
  end
end

Day10.main()
