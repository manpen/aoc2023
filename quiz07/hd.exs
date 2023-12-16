defmodule Quiz07 do
  @cards ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
  def part1(lines) do
    lines |> Enum.map(&parse_line/1) |> Enum.sort(&cmp/2) |> Enum.reverse() |> score()
  end

  @cards2 ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
  def part2(lines) do
    lines |> Enum.map(&parse_line/1) |> Enum.sort(&cmp2/2) |> Enum.reverse() |> score()
  end

  def score(list, idx \\ 1)
  def score([], _), do: 0
  def score([{_, points} | rest], idx), do: points * idx + score(rest, idx + 1)

  def typeof(hand) do
    [_, a, b, c, d, e, _] = hand |> String.split("")
    freqs = [a, b, c, d, e] |> Enum.frequencies() |> Map.values() |> Enum.sort() |> Enum.reverse()

    cond do
      freqs |> hd() == 5 ->
        0

      freqs |> hd() == 4 ->
        1

      true ->
        [a, b | _] = freqs

        cond do
          a == 3 and b == 2 -> 2
          a == 3 -> 3
          a == 2 and b == 2 -> 4
          a == 2 -> 5
          true -> 6
        end
    end
  end

  def cmp({hand1, _}, {hand2, _}) do
    [t1, t2] = [typeof(hand1), typeof(hand2)]
    t1 < t2 || (t1 == t2 && cmp_card(hand1, hand2))
  end

  def cmp_card("", ""), do: false

  def cmp_card(<<a::binary-size(1), as::binary>>, <<b::binary-size(1), bs::binary>>) do
    [i1, i2] = [Enum.find_index(@cards, &(&1 == a)), Enum.find_index(@cards, &(&1 == b))]
    i1 < i2 || (i1 == i2 && cmp_card(as, bs))
  end

  def typeof2(hand) do
    [_, a, b, c, d, e, _] = hand |> String.split("")

    freqs =
      ([a, b, c, d, e]
       |> Enum.filter(&(&1 != "J"))
       |> Enum.frequencies()
       |> Map.values()
       |> Enum.sort()
       |> Enum.reverse()) ++ [0, 0]

    jokers = [a, b, c, d, e] |> Enum.filter(&(&1 == "J")) |> Enum.count()

    cond do
      (freqs |> hd()) + jokers == 5 ->
        0

      (freqs |> hd()) + jokers == 4 ->
        1

      true ->
        [a, b | _] = freqs

        cond do
          a + jokers == 3 and b == 2 -> 2
          a + jokers == 3 -> 3
          a + jokers == 2 and b == 2 -> 4
          a + jokers == 2 -> 5
          true -> 6
        end
    end
  end

  def cmp2({hand1, _}, {hand2, _}) do
    [t1, t2] = [typeof2(hand1), typeof2(hand2)]
    t1 < t2 || (t1 == t2 && cmp_card2(hand1, hand2))
  end

  def cmp_card2("", ""), do: false

  def cmp_card2(<<a::binary-size(1), as::binary>>, <<b::binary-size(1), bs::binary>>) do
    [i1, i2] = [Enum.find_index(@cards2, &(&1 == a)), Enum.find_index(@cards2, &(&1 == b))]
    i1 < i2 || (i1 == i2 && cmp_card2(as, bs))
  end

  def parse_line(line) do
    [hand, points] = String.split(line)
    {hand, String.to_integer(points)}
  end
end

example =
  """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """
  |> String.split("\n")
  |> Enum.slice(0..-2)

lines = File.stream!("hd.in") |> Enum.to_list() |> Enum.map(&String.trim(&1, "\n"))

f = fn o, e -> "#{o} " <> ((o == e && "ok") || "FAIL, expected=#{e}") end

IO.puts("""
Example:
  1) #{f.(Quiz07.part1(example), 6_440)}
  2) #{f.(Quiz07.part2(example), 5_905)}
Input:
  1) #{f.(Quiz07.part1(lines), 256_448_566)}
  2) #{f.(Quiz07.part2(lines), 254_412_181)}
""")
