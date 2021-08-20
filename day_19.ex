defmodule Day19 do
  @input 3_017_957

  @spec main() :: :ok
  def main do
    IO.puts([
      "***********************\n",
      "ADVENT OF CODE - DAY 19\n",
      "***********************"
    ])

    IO.puts(["Part 1: ", "#{josephus(@input)}"])
    IO.puts(["Part 2: ", "#{part_2(@input)}", "\n"])
  end

  @spec josephus(integer) :: integer
  def josephus(n) do
    b = Integer.to_string(n, 2)
    {msb, rest} = String.split_at(b, 1)
    String.to_integer(rest <> msb, 2)
  end

  @spec part_2(integer) :: integer
  def part_2(n) do
    x = power_of_three(n)

    if n < x * 2, do: n - x, else: 0
  end

  @doc """
  Finds the highest power of three which is not greater than the input.
  """
  @spec power_of_three(integer) :: integer
  def power_of_three(n) do
    Stream.iterate(3, &(&1 * 3))
    |> Enum.find(&(&1 * 3 > n))
  end

  # Below functions were used to print the first 100 results for inspection.
  # They have poor time complexity and will not work for higher numbers.

  def list_part_2_results do
    Enum.each(1..100, &IO.inspect({&1, part_2_test(&1)}))
  end

  @spec part_2_test(integer) :: integer
  def part_2_test(n) do
    1..n
    |> Enum.to_list()
    |> loop()
  end

  defp loop([n]), do: n

  defp loop(list) do
    list
    |> delete_midpoint()
    |> rotate()
    |> loop()
  end

  @spec delete_midpoint(list) :: list
  def delete_midpoint(list) do
    len = length(list)
    idx = div(len, 2)
    List.delete_at(list, idx)
  end

  @spec rotate(list) :: list
  def rotate([h | rest]), do: rest ++ [h]
end

Day19.main()
