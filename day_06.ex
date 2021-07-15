defmodule Day6 do
  @spec main() :: :ok
  def main do
    with input <- File.read!("day_6_input.txt"),
         chars_by_index <- group_by_index(input) do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 6\n**********************",
        "\nPart 1: ",
        decode_message(chars_by_index, &Enum.max_by/2),
        "\nPart 2: ",
        decode_message(chars_by_index, &Enum.min_by/2),
        "\n"
      ])
    end
  end

  @spec group_by_index(binary()) :: map()
  def group_by_index(input) do
    Enum.reduce(
      String.graphemes(input),
      {%{}, 0},
      fn s, {acc, idx} ->
        if s == "\n" do
          {acc, 0}
        else
          {Map.update(acc, idx, [s], &[s | &1]), idx + 1}
        end
      end
    )
    |> elem(0)
  end

  @spec decode_message(map(), fun()) :: iolist()
  def decode_message(chars_by_index, decode_func) do
    chars_by_index
    |> Enum.reduce(
      %{},
      fn {idx, chars}, acc ->
        {top_char, _} = Enum.frequencies(chars) |> decode_func.(&elem(&1, 1))
        Map.put(acc, idx, top_char)
      end
    )
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.reduce([], fn {_, val}, acc -> [val | acc] end)
  end
end

Day6.main()
