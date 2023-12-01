defmodule Quiz01 do
  def extract_first_and_last_digit(string) do
    extract_first_and_last_digit(string, nil, nil)
  end

  defp extract_first_and_last_digit(<<>>, first, last) do
    first * 10 + last
  end

  defp extract_first_and_last_digit(<<c::binary-size(1), rest::binary>>, first, last) do
    if String.contains?("0123456789", c) do
      d = String.to_integer(c)

      if first == nil do
        extract_first_and_last_digit(rest, d, d)
      else
        extract_first_and_last_digit(rest, first, d)
      end
    else
      extract_first_and_last_digit(rest, first, last)
    end
  end

  def part1(partial \\ 0) do
    s = IO.gets("")

    if s == :eof do
      partial
    else
      part1(partial + extract_first_and_last_digit(s))
    end
  end

  @numbers ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  def to_digits(s) do
    if Regex.match?(~r/\d/, s) do
      String.to_integer(s)
    else
      Enum.find_index(@numbers, &(&1 == s)) + 1
    end
  end

  def part2(partial \\ 0) do
    s = IO.gets("")

    if s == :eof do
      partial
    else
      first = Regex.run(~r/\d|#{Enum.join(@numbers, "|")}/, s) |> hd() |> to_digits()

      last =
        Regex.run(~r/.*(\d|#{Enum.join(@numbers, "|")})/, s) |> Enum.at(-1) |> to_digits()

      current = 10 * first + last
      part2(partial + current)
    end
  end
end

# Quiz01.part1() |> IO.puts()
# = 55123

Quiz01.part2() |> IO.puts()
# = 55260
