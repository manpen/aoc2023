defmodule Quiz05 do
  def part1(lines) do
    {seeds, maps} = parse(lines)
    seeds |> Enum.map(&convert_through_maps(&1, maps)) |> Enum.min()
  end

  def part2(lines) do
    {seeds, maps} = parse(lines)

    maxnumber =
      Enum.max(
        seeds ++
          Enum.map(maps, fn {_, _, m} ->
            m
            |> Enum.map(fn {dest, src, range} -> max(src + range, dest + range) end)
            |> Enum.max()
          end)
      )

    maps =
      maps
      |> Enum.map(fn {from, to, map} ->
        {from, to,
         map
         |> Enum.sort(fn {_, src1, _}, {_, src2, _} -> src1 < src2 end)
         |> fill_gaps(maxnumber)}
      end)

    maps =
      maps
      |> Enum.map(fn {from, to, map} ->
        {_, src, _} = hd(map)

        newmap =
          if src > 0 do
            [{0, 0, src}] ++ map
          else
            map
          end

        {from, to, newmap}
      end)

    seeds
    |> to_intervals2()
    |> convert_through_maps2(maps)
    |> Enum.map(fn {lo, _hi} -> lo end)
    |> Enum.min()
  end

  def to_intervals2([]), do: []

  def to_intervals2([seed, range | seeds]) do
    [{seed, seed + range - 1} | to_intervals2(seeds)]
  end

  def fill_gaps([last | []], maxnumber) do
    {_dest, src, range} = last
    fill_src_lo = src + range
    fill_src_hi = maxnumber

    [last] ++
      if fill_src_lo <= fill_src_hi do
        [{fill_src_lo, fill_src_lo, fill_src_hi - fill_src_lo + 1}]
      else
        []
      end
  end

  def fill_gaps([r1, r2 | rest], maxnumber) do
    {d1, s1, r1} = r1
    {d2, s2, r2} = r2
    fill_src_lo = s1 + r1
    fill_src_hi = s2 - 1

    [{d1, s1, r1}] ++
      if fill_src_lo <= fill_src_hi do
        [{fill_src_lo, fill_src_lo, fill_src_hi - fill_src_lo + 1}]
      else
        []
      end ++
      fill_gaps([{d2, s2, r2} | rest], maxnumber)
  end

  def convert_through_maps(value, []), do: value

  def convert_through_maps(value, [map | rest]) do
    {_, _, map} = map
    new = convert_through_map(value, map)
    convert_through_maps(new, rest)
  end

  def convert_through_map(value, map) do
    ((map
      |> Enum.filter(fn {_, src, range} -> src <= value and value < src + range end)
      |> Enum.map(fn {dest, src, _} -> dest + (value - src) end)) ++
       [value])
    |> hd()
  end

  def convert_through_maps2(intervals, []), do: intervals

  def convert_through_maps2(intervals, [map | rest]) do
    {_, _, map} = map
    new = convert_through_map2(intervals, map)
    convert_through_maps2(new, rest)
  end

  def convert_through_map2([], _), do: []

  def convert_through_map2([interval | intervals], map) do
    (map_interval2(interval, map) ++
       convert_through_map2(intervals, map))
    |> Enum.uniq()
  end

  def map_interval2(_, []), do: []

  def map_interval2({lo, hi}, [{dest, src, range} | maps]) do
    intersection_lo = max(lo, src)
    intersection_hi = min(hi, src + range - 1)

    if intersection_lo <= intersection_hi do
      [{dest + (intersection_lo - src), dest + (intersection_hi - src)}]
    else
      []
    end ++ map_interval2({lo, hi}, maps)
  end

  def parse([seeds | maps]) do
    seeds =
      seeds
      |> String.split()
      |> Enum.slice(1..-1)
      |> Enum.map(&String.to_integer/1)

    maps = parse_maps(maps)
    {seeds, maps}
  end

  def parse_maps(lines, partial_map \\ nil)
  def parse_maps([], partial_map), do: (partial_map != nil && [partial_map]) || []
  def parse_maps([<<>> | rest], partial_map), do: parse_maps([], partial_map) ++ parse_maps(rest)

  def parse_maps([line | rest], partial_map) do
    if Regex.match?(~r/(\w+)-to-(\w+) map:/, line) do
      [_, from, to] = Regex.run(~r/(\w+)-to-(\w+) map:/, line)
      parse_maps(rest, {from, to, []})
    else
      [dest, src, range] = line |> String.split() |> Enum.map(&String.to_integer/1)
      {from, to, map} = partial_map
      parse_maps(rest, {from, to, map ++ [{dest, src, range}]})
    end
  end
end

example =
  """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz05.part1(example), 35)}
  2) #{f.(Quiz05.part2(example), 46)}
Input:
  1) #{f.(Quiz05.part1(lines), 240_320_250)}
  2) #{f.(Quiz05.part2(lines), 28_580_589)}
""")
