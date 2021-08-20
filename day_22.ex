defmodule Day22 do
  @spec main() :: :ok
  def main do
    with f <- File.read!("day_22_input.txt"),
         input <- parse_input(f) do
      avail = Enum.group_by(input, &trim_input(Enum.at(&1, 3)), &Enum.at(&1, 0))

      max_avail = avail |> Map.keys() |> Enum.max()

      a =
        Enum.reduce(max_avail..2//-1, avail, fn size, acc ->
          Map.update(acc, size - 1, acc[size], &Enum.concat(&1, acc[size]))
        end)

      needs =
        input
        |> Stream.map(fn [name, _, used, _, _] -> {name, trim_input(used)} end)
        |> Enum.reject(fn {_name, used} -> used == 0 end)

      res =
        Enum.reduce(needs, 0, fn {name, needed}, acc ->
          potential_others =
            case a[needed] do
              nil ->
                []

              potentials ->
                Enum.reject(potentials, &(&1 == name))
            end

          acc + length(potential_others)
        end)

      IO.puts([
        "***********************\n",
        "ADVENT OF CODE - DAY 22\n",
        "***********************\n",
        "#{res}"
      ])
    end
  end

  @spec parse_input(binary) :: list(list(binary))
  def parse_input(txt) do
    txt
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.drop(2)
  end

  @spec trim_input(binary) :: integer
  def trim_input(txt) do
    txt
    |> String.slice(0..-2//1)
    |> String.to_integer()
  end
end

Day22.main()
