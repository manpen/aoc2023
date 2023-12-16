defmodule Quiz01 do
  @numbers ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  def to_digits(s), do: Enum.find_index(@numbers, &(&1 == s)) || String.to_integer(s)

  def part1([]), do: 0

  def part1([line | rest]) do
    first = Regex.run(~r/\d/, line) |> hd() |> to_digits()
    last = Regex.run(~r/.*(\d)/, line) |> Enum.at(1) |> to_digits()
    current = 10 * first + last
    current + part1(rest)
  end

  def part2([]), do: 0

  def part2([line | rest]) do
    first = Regex.run(~r/\d|#{Enum.join(@numbers, "|")}/, line) |> hd() |> to_digits()
    last = Regex.run(~r/.*(\d|#{Enum.join(@numbers, "|")})/, line) |> Enum.at(1) |> to_digits()
    current = 10 * first + last
    current + part2(rest)
  end
end

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
  1) #{f.(Quiz01.part1(lines), 55123)}
  2) #{f.(Quiz01.part2(lines), 55260)}
""")
