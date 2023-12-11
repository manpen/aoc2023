defmodule Quiz11 do
  def part1(lines) do
    lines = lines |> Enum.map(&(String.split(&1, "") |> Enum.filter(fn c -> c != "" end)))
    lines = lines |> expand_rows() |> transpose() |> expand_rows() |> transpose()
    h = length(lines)
    w = length(hd(lines))

    lines = lines |> Enum.map(&List.to_tuple/1) |> List.to_tuple()

    galaxies =
      for x <- 0..(h - 1), y <- 0..(w - 1) do
        {x, y}
      end
      |> Enum.filter(fn {x, y} -> lines |> elem(x) |> elem(y) == "#" end)

    for {a, b} <- galaxies, {c, d} <- galaxies do
      abs(a - c) + abs(b - d)
    end
    |> Enum.sum()
    |> div(2)
  end

  def part2(lines) do
    lines = lines |> Enum.map(&(String.split(&1, "") |> Enum.filter(fn c -> c != "" end)))
    h = length(lines)
    w = length(hd(lines))
    lines = lines |> Enum.map(&List.to_tuple/1) |> List.to_tuple()

    empty_rows =
      for i <- 0..(h - 1), lines |> elem(i) |> Tuple.to_list() |> Enum.all?(&(&1 == ".")) do
        i
      end

    empty_cols =
      for j <- 0..(w - 1),
          Enum.all?(lines |> Tuple.to_list(), fn row -> elem(row, j) == "." end) do
        j
      end

    galaxies =
      for x <- 0..(h - 1), y <- 0..(w - 1) do
        {x, y}
      end
      |> Enum.filter(fn {x, y} -> lines |> elem(x) |> elem(y) == "#" end)

    for {a, b} <- galaxies, {c, d} <- galaxies do
      dist({a, b}, {c, d}, empty_rows, empty_cols)
    end
    |> Enum.sum()
    |> div(2)
  end

  def dist({a, b}, {c, d}, empty_rows, empty_cols) do
    num_er = empty_rows |> Enum.count(&((a < &1 and &1 < c) or (c < &1 and &1 < a)))
    num_ec = empty_cols |> Enum.count(&((b < &1 and &1 < d) or (d < &1 and &1 < b)))

    abs(a - c) - num_er + abs(b - d) - num_ec + 1_000_000 * (num_er + num_ec)
  end

  def expand_rows([]), do: []

  def expand_rows([row | rows]) do
    if Enum.any?(row, &(&1 == "#")) do
      [row | expand_rows(rows)]
    else
      [row, row | expand_rows(rows)]
    end
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end

example =
  """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz11.part1(example), 374)}
  2) #{f.(Quiz11.part2(example), 82_000_210)}
Input:
  1) #{f.(Quiz11.part1(lines), 9_648_398)}
  2) #{f.(Quiz11.part2(lines), 618_800_410_814)}
""")
