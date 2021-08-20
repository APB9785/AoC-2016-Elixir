defmodule Day4 do
  @spec main() :: :ok
  def main do
    with input <- parse_input(),
         decoded <- Enum.map(input, &decrypt_room_name/1) do
      IO.puts([
        "**********************\nADVENT OF CODE - DAY 4\n**********************",
        "\nPart 1: ",
        "#{part_1(input)}",
        "\nPart 2: ",
        "#{part_2(decoded)}",
        "\n"
      ])
    end
  end

  @spec parse_input() :: Enumerable.t()
  def parse_input do
    File.read!("day_4_input.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(&Regex.run(~r/([a-z-]+)-(\d+)\[(\w+)]/, &1))
    |> Stream.map(fn [_, a, b, c] -> {a, String.to_integer(b), c} end)
  end

  @spec part_1(Enumerable.t()) :: integer
  def part_1(input_stream) do
    Enum.reduce(input_stream, 0, fn x, acc ->
      if is_real_room?(x), do: acc + elem(x, 1), else: acc
    end)
  end

  @spec part_2(list({binary, integer})) :: integer
  def part_2(decoded_list) do
    {_, id} = Enum.find(decoded_list, &String.contains?(elem(&1, 0), "north"))
    id
  end

  @spec is_real_room?({binary, integer, binary}) :: boolean
  defp is_real_room?({encrypted_name, _sector_id, checksum}) do
    encrypted_name
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.delete("-")
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.take(5)
    |> Stream.map(&elem(&1, 0))
    |> Enum.join()
    |> then(&(&1 == checksum))
  end

  @spec decrypt_room_name({binary, integer, binary}) :: {binary, integer}
  def decrypt_room_name({encrypted_name, sector_id, _checksum}) do
    encrypted_name
    |> String.graphemes()
    |> Stream.map(&:binary.first/1)
    |> Stream.map(fn val -> if val == 45, do: " ", else: [rem(val - 97 + sector_id, 26) + 97] end)
    |> Enum.join()
    |> then(&{&1, sector_id})
  end
end

Day4.main()
