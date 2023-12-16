#!/usr/bin/env python3


def part1(lines: list[str]):
    bs = list(blocks(lines))
    return sum(value(b) for b in bs)


def part2(lines: list[str]):
    bs = list(blocks(lines))
    return sum(value(b, 1) for b in bs)


def value(block: list[str], num_false=0):
    for i in range(len(block) - 1):
        if symmetric_updown(block, i) == num_false:
            print("updown", i)
            return 100 * (i + 1)
    for i in range(len(block[0]) - 1):
        if symmetric_leftright(block, i) == num_false:
            print("leftright", i)
            return i + 1


def symmetric_updown(block: list[str], i: int):
    num_false = 0
    for j in range(len(block)):
        if i - j < 0 or i + j + 1 >= len(block):
            break
        for k in range(len(block[0])):
            if block[i - j][k] != block[i + j + 1][k]:
                num_false += 1
    return num_false


def symmetric_leftright(block: list[str], i: int):
    num_false = 0
    for j in range(len(block[0])):
        if i - j < 0 or i + j + 1 >= len(block[0]):
            break
        for line in block:
            if line[i - j] != line[i + j + 1]:
                num_false += 1
    return num_false


def blocks(lines: list[str]):
    block = []
    for y in lines:
        if y == "":
            yield block
            block = []
        else:
            block.append(y)
    yield block


def test(o, e):
    return f"{o}   ok" if o == e else f"{o}   FAIL: expected={e}"


lines = list(map(str.strip, open("hd.in").readlines()))
example = list(
    map(
        str.strip,
        """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
""".strip().splitlines(),
    )
)
print(
    f"""
Example:
  1) {test(part1(example), 405)}
  2) {test(part2(example), 400)}
Input:
  1) {test(part1(lines), 37718)}
  2) {test(part2(lines), None)}
"""
)
