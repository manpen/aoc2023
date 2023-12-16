#!/usr/bin/env python3
from collections import OrderedDict


def part1(lines: list[str]):
    return sum(map(h, lines[0].split(",")))


def part2(lines: list[str]):
    boxes = [OrderedDict() for _ in range(256)]
    for cmd in lines[0].split(","):
        if cmd.find("=") >= 0:
            k, v = cmd.split("=")
            boxes[h(k)][k] = int(v)
        elif cmd.find("-") >= 0:
            k, v = cmd.split("-")
            if k in boxes[h(k)]:
                del boxes[h(k)][k]
    power = 0
    for boxnumber in range(256):
        for slotnumber, focal in enumerate(boxes[boxnumber]):
            power += (1+boxnumber) * (1+slotnumber) * (boxes[boxnumber][focal])
    return power


def h(cmd: str, cur_val=0):
    if len(cmd) == 0:
        return cur_val
    return h(cmd[1:], ((cur_val + ord(cmd[0])) * 17) % 256)


def test(o, e):
    return f"{o}, ok" if o == e else f"{o}    FAIL: expected={e}"


lines = list(map(str.strip, open("hd.in").readlines()))
example = list(
    map(
        str.strip,
        """
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
""".strip().splitlines(),
    )
)
print(
    f"""
Example:
  1) {test(part1(example), 1320)}
  2) {test(part2(example), 145)}
Input:
  1) {test(part1(lines), 510273)}
  2) {test(part2(lines), 212449)}
"""
)
