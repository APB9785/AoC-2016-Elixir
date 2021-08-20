defmodule Day14 do
  @salt "ahsbgdzn"

  @spec main() :: :ok
  def main do
    IO.puts([
      "***********************\n",
      "ADVENT OF CODE - DAY 14\n",
      "***********************"
    ])

    IO.puts(["Part 1: ", "#{run(:part_1)}"])
    IO.puts(["Part 2: ", "#{run(:part_2)}", "\n"])
  end

  @spec run(:part_1 | :part_2) :: integer
  def run(part), do: run(0, [], part)

  defp run(_, found, _) when length(found) == 64, do: hd(found)

  defp run(idx, found, part) do
    r = Range.new(idx + 1, idx + 1000, 1)

    case :ets.lookup(part, idx) do
      [{_, nil, _}] ->
        run(idx + 1, found, part)

      [{_, triple, _}] ->
        if Enum.any?(r, &has_fiver?(&1, triple, part)) do
          run(idx + 1, [idx | found], part)
        else
          run(idx + 1, found, part)
        end

      [] ->
        {idx, triple, fives} = hash_tuple(idx, part)
        :ets.insert(part, {idx, triple, fives})

        if Enum.any?(r, &has_fiver?(&1, triple, part)) do
          run(idx + 1, [idx | found], part)
        else
          run(idx + 1, found, part)
        end
    end
  end

  @spec hash_tuple(integer, :part_1 | :part_2) :: {integer, binary, list(binary)}
  def hash_tuple(idx, part) do
    hash =
      case part do
        :part_1 -> md5("#{@salt}#{idx}", 1)
        :part_2 -> md5("#{@salt}#{idx}", 2017)
      end

    triple =
      case Regex.run(~r/(.)\1{2}/, hash) do
        [_, t] -> t
        nil -> nil
      end

    fives =
      Regex.scan(~r/(.)\1{4}/, hash)
      |> Enum.map(&List.last/1)

    {idx, triple, fives}
  end

  @spec has_fiver?(integer, binary, :part_1 | :part_2) :: boolean
  def has_fiver?(idx, triple, part) do
    case :ets.lookup(part, idx) do
      [{_, _, fives}] ->
        triple in fives

      [] ->
        {idx, new_triple, fives} = hash_tuple(idx, part)
        :ets.insert(part, {idx, new_triple, fives})
        triple in fives
    end
  end

  @spec md5(binary, integer) :: binary
  def md5(text, 0), do: text

  def md5(text, count) do
    new_text = :crypto.hash(:md5, text) |> Base.encode16(case: :lower)
    md5(new_text, count - 1)
  end
end

:ets.new(:part_1, [:named_table])
:ets.new(:part_2, [:named_table])
Day14.main()
