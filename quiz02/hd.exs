defmodule Quiz02 do
  defp color_possible("red", count), do: count <= 12
  defp color_possible("green", count), do: count <= 13
  defp color_possible("blue", count), do: count <= 14
  defp color_possible(_color, _count), do: true

  defp set_possible([]), do: true

  defp set_possible([cube | rest]) do
    [count, color] = cube |> String.split()
    count = String.to_integer(count)
    color_possible(color, count) && set_possible(rest)
  end

  defp game_possible([]), do: true

  defp game_possible([set | rest]) do
    set_possible(set |> String.split(", ")) && game_possible(rest)
  end

  def possible_id(line) do
    [game_id, game] = String.split(line, ": ")
    id = game_id |> String.split() |> Enum.at(-1) |> String.to_integer()

    sets = game |> String.split("; ")

    if game_possible(sets) do
      id
    else
      0
    end
  end

  def part1(lines) do
    lines |> Enum.map(&possible_id(&1)) |> Enum.sum()
  end

  def power(line) do
    String.split(line, ": ")
    |> Enum.at(-1)
    |> String.split(["; ", ", "])
    |> Enum.map(&String.split(&1, " "))
    |> Enum.reduce(%{}, fn [count, color], acc ->
      count = String.to_integer(count)

      if acc[color] == nil || count > acc[color] do
        Map.put(acc, color, count)
      else
        acc
      end
    end)
    |> Map.values()
    |> Enum.product()
  end

  def part2(lines) do
    lines |> Enum.map(&power(&1)) |> Enum.sum()
  end
end

lines = IO.stream(:stdio, :line) |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

# 2617
lines |> Quiz02.part1() |> IO.puts()

# 59795
lines |> Quiz02.part2() |> IO.puts()

if Enum.member?(System.argv(), "--test") do
  ExUnit.start()
  import ExUnit.Assertions

  defmodule Test do
    def test(text, quiz, expected) do
      text
      |> String.split("\n")
      |> Enum.slice(0..-2)
      |> quiz.()
      |> (&assert(&1 == expected)).()
    end
  end

  example =
    """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

  example |> Test.test(&Quiz02.part1/1, 8)
  example |> Test.test(&Quiz02.part2/1, 2286)
end
