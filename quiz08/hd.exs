defmodule BasicMath do
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))
end

defmodule Quiz08 do
  def part1(lines) do
    {dirs, graph} = parse(lines)
    walk(dirs, graph)
  end

  def part2(lines) do
    {dirs, graph} = parse(lines)
    wavefront = Map.keys(graph) |> Enum.filter(&(String.at(&1, 2) == "A"))
    periods = Enum.map(wavefront, &walk2(dirs, graph, 0, &1)) |> Enum.flat_map(&Map.values(&1))
    Enum.reduce(periods, fn x, acc -> BasicMath.lcm(x, acc) end)
  end

  def walk(dirs, graph, pos \\ 0, cur \\ "AAA") do
    cur = step(String.at(dirs, pos), graph, cur)
    1 + ((cur != "ZZZ" && walk(dirs, graph, rem(pos + 1, String.length(dirs)), cur)) || 0)
  end

  def step(dir, graph, cur) do
    elem(graph[cur], (dir == "L" && 0) || 1)
  end

  def walk2(dirs, graph, pos \\ 0, cur, map \\ %{}, length \\ 0) do
    if Map.has_key?(map, {cur, pos}) do
      map
    else
      map =
        if String.at(cur, 2) == "Z" do
          Map.put(map, {cur, pos}, length)
        else
          map
        end

      cur = step(String.at(dirs, pos), graph, cur)
      walk2(dirs, graph, rem(pos + 1, String.length(dirs)), cur, map, length + 1)
    end
  end

  def parse([dirs, _ | graph]), do: {dirs, parse_graph(graph)}

  def parse_graph([]), do: %{}

  def parse_graph([line | rest]) do
    [v, _, left, right] = String.split(line)
    left = String.slice(left, 1..-2)
    right = String.slice(right, 0..-2)
    Map.put(parse_graph(rest), v, {left, right})
  end
end

example =
  """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

example2 =
  """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz08.part1(example), 6)}
  2) #{f.(Quiz08.part2(example2), 6)}
Input:
  1) #{f.(Quiz08.part1(lines), 12_737)}
  2) #{f.(Quiz08.part2(lines), 9_064_949_303_801)}
""")
