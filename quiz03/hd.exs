defmodule Quiz03 do
  @dirs [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]

  def number_at(lines, n, m, i, j) do
    symb = lines |> elem(i) |> String.at(j)

    is_digit = Regex.match?(~r/\d/, symb)
    is_start = j == 0 || not Regex.match?(~r/\d/, lines |> elem(i) |> String.at(j - 1))

    if is_digit && is_start do
      {number, _} = lines |> elem(i) |> String.slice(j, 150) |> Integer.parse()
      length = String.length(to_string(number))

      is_active =
        Enum.any?(j..(j + length - 1), fn j ->
          Enum.any?(@dirs, fn {di, dj} ->
            ii = i + di
            jj = j + dj

            0 <= ii && ii < m && 0 <= jj && jj < n &&
              (
                c = lines |> elem(ii) |> String.at(jj)
                not Regex.match?(~r/\d|\./, c)
              )
          end)
        end)

      (is_active && {i, j, number}) || nil
    end
  end

  def part1(lines) do
    m = length(lines)
    n = String.length(hd(lines))
    lines = lines |> List.to_tuple()

    vertices = for i <- 0..(m - 1), j <- 0..(n - 1), do: {i, j}

    relevant_numbers =
      Enum.map(
        vertices,
        fn {i, j} -> number_at(lines, n, m, i, j) end
      )
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(&elem(&1, 2))

    relevant_numbers |> Enum.sum()
  end

  defp find_start(lines, n, m, i, j) do
    c = lines |> elem(i) |> String.at(j)

    number_at(lines, n, m, i, j) ||
      (j > 0 && Regex.match?(~r/\d/, c) && find_start(lines, n, m, i, j - 1))
  end

  def neighboring_numbers(lines, n, m, i, j) do
    Enum.map(@dirs, fn {di, dj} ->
      ii = i + di
      jj = j + dj
      (ii >= 0 && ii < m && jj >= 0 && jj < n && find_start(lines, n, m, ii, jj)) || nil
    end)
    |> Enum.filter(&(&1 != nil))
    |> Enum.uniq()
    |> Enum.map(&elem(&1, 2))
  end

  def part2(lines) do
    m = length(lines)
    n = String.length(hd(lines))
    lines = lines |> List.to_tuple()

    for(i <- 0..(m - 1), j <- 0..(n - 1), do: {i, j})
    |> Enum.map(fn {i, j} ->
      (lines |> elem(i) |> String.at(j) == "*" &&
         (
           neighbors = neighboring_numbers(lines, n, m, i, j)
           length(neighbors) == 2 && Enum.product(neighbors)
         )) || 0
    end)
    |> Enum.sum()
  end
end

example =
  """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz03.part1(example), 4361)}
  2) #{f.(Quiz03.part2(example), 467_835)}
Input:
  1) #{f.(Quiz03.part1(lines), 514_969)}
  2) #{f.(Quiz03.part2(lines), 78_915_902)}
""")
