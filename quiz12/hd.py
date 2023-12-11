#!/usr/bin/env python3

memo = {}


def part1(lines: list[str]):
    return sum(combinations(line) for line in lines)


def part2(lines: list[str]):
    return sum(combinations2(line) for line in lines)


def combinations(line: str):
    chars, counts = line.split()
    counts = tuple(map(int, counts.split(",")))
    return rec(chars, counts)


def combinations2(line: str):
    chars, counts = line.split()
    chars = "?".join([chars] * 5)
    counts = ",".join([counts] * 5)
    counts = tuple(map(int, counts.split(",")))
    return rec(chars, counts)


def rec(chars: str, counts: tuple[int]):
    global memo
    if (chars, counts) in memo:
        return memo[(chars, counts)]

    ret = -1111
    if len(counts) == 0 and chars.find("#") != -1:
        ret = 0
    elif len(counts) == 0:
        ret = 1
    elif len(chars) < counts[0]:
        ret = 0
    elif chars[0] == ".":
        ret = rec(chars[1:], counts)
    else:
        ret = 0
        if chars[0] == "?":
            ret += rec(chars[1:], counts)
        if chars[: counts[0]].find(".") == -1:
            if len(chars) == counts[0]:
                ret += rec(chars[counts[0] :], counts[1:])
            elif chars[counts[0]] in ["?", "."]:
                ret += rec(chars[counts[0] + 1 :], counts[1:])

    memo[(chars, counts)] = ret
    return ret


def test(o, e):
    return f"{o}, ok" if o == e else f"{o}    FAIL: expected={e}"


lines = list(map(str.strip, open("hd.in").readlines()))
example = list(
    map(
        str.strip,
        """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".strip().splitlines(),
    )
)
print(
    f"""
Example:
  1) {test(part1(example), 21)}
  2) {test(part2(example), 525152)}
Input:
  1) {test(part1(lines), 7191)}
  2) {test(part2(lines), 6512849198636)}
"""
)
