defmodule Quiz06 do
  def part1([times, distances]) do
    times = String.split(times) |> Enum.slice(1, 99) |> Enum.map(&String.to_integer/1)

    distances =
      String.split(distances) |> Enum.slice(1, 99) |> Enum.map(&String.to_integer/1)

    races = Enum.zip(times, distances)
    races |> Enum.map(&ways_to_win/1) |> Enum.product()
  end

  def part2([times, distances]) do
    time = String.split(times) |> Enum.slice(1, 99) |> Enum.join("") |> String.to_integer()

    distance =
      String.split(distances) |> Enum.slice(1, 99) |> Enum.join("") |> String.to_integer()

    ways_to_win({time, distance})
  end

  def ways_to_win({time, distance}), do: ways_to_win({time, distance}, time)

  def ways_to_win(_race, 0), do: 0

  def ways_to_win({time, distance}, push) do
    ways_to_win({time, distance}, push - 1) + ((push * (time - push) > distance && 1) || 0)
  end
end

example =
  """
  Time:      7  15   30
  Distance:  9  40  200
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz06.part1(example), 288)}
  2) #{f.(Quiz06.part2(example), 71503)}
Input:
  1) #{f.(Quiz06.part1(lines), 1_312_850)}
  2) #{f.(Quiz06.part2(lines), 36_749_103)}
""")
