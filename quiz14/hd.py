#!/usr/bin/env python3


def part1(lines: list[str]):
    lines = list(map(list, lines))
    lines = bubble_up(lines)
    return value(lines)


def bubble_up(lines: list[list[str]]):
    for c in range(len(lines[0])):
        available = 0
        for r in range(len(lines)):
            if lines[r][c] == "#":
                available = r + 1
            elif lines[r][c] == "O":
                lines[r][c] = "."
                lines[available][c] = "O"
                available += 1
    return lines


def value(lines: list[list[str]]):
    ret = 0
    for r in range(len(lines)):
        for c in range(len(lines[0])):
            if lines[r][c] == "O":
                ret += len(lines) - r
    return ret


def part2(lines: list[str]):
    lines = list(map(list, lines))
    period = {}
    cycles = 1000000000
    for when in range(cycles):
        for _ in range(4):
            lines = bubble_up(lines)
            lines = rotate_right(lines)
        print("\n".join(map("".join, lines)))
        val = value(lines)
        print(f"{val} ---")
        t = tuple(map(tuple, lines))
        if t in period:
            print(period)
            print(f"when={when}")
            val = value(lines)
            (_, last) = period[t]
            period_start = last
            period_length = when - last
            print(f"period_start={period_start}")
            print(f"period_length={period_length}")
            target = period_start + ((cycles - period_start - 1) % period_length)
            print(f"target={target}")
            for v, w in period.values():
                if w == target:
                    return v
        else:
            period[t] = (val, when)
    return value(lines)


def rotate_right(lines: list[list[str]]):
    return list(map(list, zip(*lines[::-1])))


def test(o, e):
    return f"{o}, ok" if o == e else f"{o}    FAIL: expected={e}"


lines = list(map(str.strip, open("hd.in").readlines()))
example = list(
    map(
        str.strip,
        """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
""".strip().splitlines(),
    )
)
print(
    f"""
Example:
  1) {test(part1(example), 136)}
  2) {test(part2(example), 64)}
Input:
  1) {test(part1(lines), 109654)}
  2) {test(part2(lines), None)}
"""
)
