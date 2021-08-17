defmodule Day25 do
  @target "10101010101010101010101010101010101010101010101010101010"

  @spec main() :: :ok
  def main do
    d = 282 * 9

    Enum.find(1..99999, &valid?(&1 + d))
    |> IO.puts()
  end

  @spec valid?(integer()) :: boolean()
  def valid?(n) do
    bin = Integer.to_string(n, 2)
    String.starts_with?(@target, bin) and String.last(bin) == "0"
  end
end

Day25.main()
