defmodule Quiz04 do
  def parse(line) do
    [card, text] = line |> String.split(":")
    card = card |> String.trim() |> String.split(" ") |> List.last() |> String.to_integer()
    [winning, have] = text |> String.split("|")
    winning = winning |> String.trim() |> String.split() |> Enum.map(&String.to_integer/1)
    have = have |> String.trim() |> String.split() |> Enum.map(&String.to_integer/1)
    {card, winning, have}
  end

  def part1(lines) do
    lines
    |> Enum.map(&parse/1)
    |> Enum.map(fn {_, winning, have} ->
      c = Enum.count(winning, &Enum.member?(have, &1))
      (c == 0 && 0) || 2 ** (c - 1)
    end)
    |> Enum.sum()
  end

  def rec_add_cards(cards, {card, winning, have}) do
    c = Enum.count(winning, &Enum.member?(have, &1))

    [{card, winning, have}] ++
      ((c == 0 && []) ||
         Enum.flat_map(card..(card + c - 1), fn i ->
           newcard = Enum.at(cards, i)
           rec_add_cards(cards, newcard)
         end))
  end

  def part2(lines) do
    cards = lines |> Enum.map(&parse/1)
    cards |> Enum.flat_map(&rec_add_cards(cards, &1)) |> length()
  end
end

example =
  """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz04.part1(example), 13)}
  2) #{f.(Quiz04.part2(example), 30)}
Input:
  1) #{f.(Quiz04.part1(lines), 24175)}
  2) #{f.(Quiz04.part2(lines), 18846301)}
""")
