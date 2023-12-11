defmodule Quiz07 do
  def part1(lines) do
    {_w, _h, _verts, start, lines} = parse_graph(lines)
    bfs(lines, [start], [])
  end

  def part2(lines) do
    {w, h, _verts, _start, lines} = parse_graph(lines)

    stretched_graph =
      for i <- 0..(2 * h + 1) do
        for j <- 0..(2 * w + 1) do
          if i == 0 or j == 0 do
            "."
          else
            if i == 2 * h + 1 or j == 2 * w + 1 do
              "."
            else
              stretch({i, j}, lines)
            end
          end
        end
        |> List.to_tuple()
      end
      |> List.to_tuple()

    start =
      for i <- 1..(2 * h), j <- 1..(2 * w) do
        {i, j}
      end
      |> Enum.filter(fn {i, j} -> stretched_graph |> elem(i) |> elem(j) == "S" end)
      |> hd()

    loop = bfs2(stretched_graph, [start], []) |> MapSet.new()

    reduced_graph =
      for i <- 0..(2 * h + 2) do
        for j <- 0..(2 * w + 2) do
          if {i, j} in loop do
            stretched_graph |> elem(i) |> elem(j)
          else
            "."
          end
        end
        |> List.to_tuple()
      end
      |> List.to_tuple()

    for i <- 0..(2 * h + 2) do
      for j <- 0..(2 * w + 2) do
        if {i, j} in loop do
          stretched_graph |> elem(i) |> elem(j)
        else
          "."
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()

    exclude = flood_fill(reduced_graph, [{0, 0}], [], w, h) |> MapSet.new()

    temp =
      for i <- 0..(2 * h + 1) do
        for j <- 0..(2 * w + 1) do
          if {i, j} in loop do
            stretched_graph |> elem(i) |> elem(j)
          else
            if rem(i, 2) == 0 and rem(j, 2) == 0 and {i, j} not in exclude do
              "I"
            else
              "."
            end
          end
        end
        |> Enum.join()
      end
      |> Enum.join("\n")

    # exclude |> IO.inspect()
    temp |> IO.puts()

    for i <- 1..(2 * h) do
      for j <- 1..(2 * w) do
        if rem(i, 2) == 0 and rem(j, 2) == 0 and {i, j} not in exclude and {i, j} not in loop do
          1
        else
          0
        end
      end
      |> Enum.sum()
    end
    |> Enum.sum()
  end

  def bfs(lines, wavefront, parents) do
    nextwave =
      Enum.flat_map(wavefront, fn v -> neighbors(v, lines) end)
      |> Enum.uniq()
      |> Enum.reject(fn v -> parents |> Enum.any?(fn x -> x == v end) end)

    if nextwave == [] do
      0
    else
      1 + bfs(lines, nextwave, wavefront)
    end
  end

  def bfs2(lines, wavefront, parents) do
    nextwave =
      Enum.flat_map(wavefront, fn v -> neighbors(v, lines) end)
      |> Enum.uniq()
      |> Enum.reject(fn v -> parents |> Enum.any?(fn x -> x == v end) end)

    if nextwave == [] do
      wavefront
    else
      wavefront ++ bfs2(lines, nextwave, wavefront)
    end
  end

  def dual_neighbors(v, lines, w, h) do
    [north(v), south(v), east(v), west(v)]
    |> Enum.filter(fn {ii, jj} ->
      ii >= 0 and jj >= 0 and ii <= 2 * h + 1 and jj <= 2 * w + 1 and
        (lines |> elem(ii) |> elem(jj) == "." or lines |> elem(ii) |> elem(jj) == "")
    end)
  end

  def flood_fill(lines, wavefront, parents, w, h) do
    nextwave =
      Enum.flat_map(wavefront, fn v -> dual_neighbors(v, lines, w, h) end)
      |> Enum.uniq()
      |> Enum.reject(fn v -> parents |> Enum.any?(fn x -> x == v end) end)

    if nextwave == [] do
      wavefront
    else
      wavefront ++ flood_fill(lines, nextwave, wavefront, w, h)
    end
  end

  def parse_graph(lines) do
    h = length(lines)
    w = String.length(lines |> hd)

    lines =
      [
        Enum.join(
          for _ <- 1..w do
            "."
          end
        )
      ] ++ lines

    lines = lines |> Enum.map(&(String.split(&1, "") |> List.to_tuple())) |> List.to_tuple()

    verts =
      for i <- 1..h, j <- 1..w do
        {i, j}
      end

    start = verts |> Enum.filter(fn {i, j} -> lines |> elem(i) |> elem(j) == "S" end) |> hd()
    {w, h, verts, start, lines}
  end

  def neighbors({i, j}, lines) do
    symb = lines |> elem(i) |> elem(j)

    case symb do
      "|" ->
        [north({i, j}), south({i, j})]

      "-" ->
        [east({i, j}), west({i, j})]

      "F" ->
        [east({i, j}), south({i, j})]

      "7" ->
        [south({i, j}), west({i, j})]

      "J" ->
        [west({i, j}), north({i, j})]

      "L" ->
        [north({i, j}), east({i, j})]

      "S" ->
        [north({i, j}), south({i, j}), east({i, j}), west({i, j})]
        |> Enum.filter(fn v -> neighbors(v, lines) |> Enum.any?(fn x -> x == {i, j} end) end)

      "." ->
        []

      "" ->
        []
    end
  end

  def north({i, j}) do
    {i - 1, j}
  end

  def south({i, j}) do
    {i + 1, j}
  end

  def east({i, j}) do
    {i, j + 1}
  end

  def west({i, j}) do
    {i, j - 1}
  end

  def stretch({i, j}, lines) do
    ii = div(i, 2)
    jj = div(j, 2)

    if rem(i, 2) == 0 do
      if rem(j, 2) == 0 do
        lines |> elem(ii) |> elem(jj)
      else
        if neighbors({ii, jj}, lines) |> Enum.any?(fn x -> x == {ii, jj + 1} end) do
          "-"
        else
          "."
        end
      end
    else
      if rem(j, 2) == 0 do
        if neighbors({ii, jj}, lines) |> Enum.any?(fn x -> x == {ii + 1, jj} end) do
          "|"
        else
          "."
        end
      else
        "."
      end
    end
  end
end

example =
  """
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

example2 =
  """
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz07.part1(example), 8)}
  2) #{f.(Quiz07.part2(example2), 10)}
Input:
  1) #{f.(Quiz07.part1(lines), 7_107)}
  2) #{f.(Quiz07.part2(lines), 281)}
""")
