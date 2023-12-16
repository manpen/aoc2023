defmodule Quiz09 do
  def part1(lines) do
    lines |> Enum.map(&parse_line/1) |> Enum.map(&extrapolate/1) |> Enum.sum()
  end

  def part2(lines) do
    lines |> Enum.map(&parse_line/1) |> Enum.map(&extrapolate2/1) |> Enum.sum()
  end

  def parse_line(line) do
    line |> String.split() |> Enum.map(&String.to_integer/1)
  end

  def extrapolate(line) do
    infer(down(line))
  end

  def infer([]), do: 0

  def infer([line | rest]) do
    last = line |> Enum.at(-1)
    last + infer(rest)
  end

  def extrapolate2(line) do
    infer2(down(line))
  end

  def infer2([]), do: 0

  def infer2([line | rest]) do
    first = line |> hd()
    first - infer2(rest)
  end

  def down(line) do
    [line] ++
      if Enum.all?(line, &(&1 == 0)) do
        []
      else
        down(line |> differences())
      end
  end

  def differences([x, y | rest]) do
    [y - x | differences([y | rest])]
  end

  def differences([_]), do: []
end

example =
  """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz09.part1(example), 114)}
  2) #{f.(Quiz09.part2(example), 2)}
Input:
  1) #{f.(Quiz09.part1(lines), 1_702_218_515)}
  2) #{f.(Quiz09.part2(lines), 925)}
""")
