#!/usr/bin/env python3


def part1(lines: list[str]):
    board = [list(line) for line in lines]
    return energized(raycast(board, 0, 0, 1, 0))


def raycast(board, x: int, y: int, dx: int, dy: int, rays=None):
    if rays is None:
        rays = [[set() for _ in board[0]] for _ in board]
    while 0 <= x < len(board[0]) and 0 <= y < len(board):
        if (dx, dy) in rays[y][x]:
            break
        rays[y][x].add((dx, dy))
        if (
            board[y][x] == "."
            or (dy == 0 and board[y][x] == "-")
            or (dx == 0 and board[y][x] == "|")
        ):
            x += dx
            y += dy
            continue
        elif board[y][x] == "|":
            raycast(board, x, y + 1, 0, 1, rays)
            raycast(board, x, y - 1, 0, -1, rays)
            break
        elif board[y][x] == "-":
            raycast(board, x + 1, y, 1, 0, rays)
            raycast(board, x - 1, y, -1, 0, rays)
            break
        elif board[y][x] == "/":
            dx, dy = -dy, -dx
        elif board[y][x] == "\\":
            dx, dy = dy, dx
        x += dx
        y += dy
    return rays


def energized(rays):
    s = 0
    for row in rays:
        for cell in row:
            if len(cell) >= 1:
                s += 1
    return s


def part2(lines: list[str]):
    board = [list(line) for line in lines]
    return max(
        max(energized(raycast(board, 0, i, 1, 0)) for i in range(len(board))),
        max(energized(raycast(board, i, 0, 0, 1)) for i in range(len(board[0]))),
        max(
            energized(raycast(board, len(board[0]) - 1, i, -1, 0))
            for i in range(len(board))
        ),
        max(
            energized(raycast(board, i, len(board) - 1, 0, -1))
            for i in range(len(board[0]))
        ),
    )


def test(o, e):
    return f"{o}, ok" if o == e else f"{o}    FAIL: expected={e}"


lines = list(map(str.strip, open("hd.in").readlines()))
example = list(
    map(
        str.strip,
        r"""
.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....
""".strip().splitlines(),
    )
)
print(
    f"""
Example:
  1) {test(part1(example), 46)}
  2) {test(part2(example), 51)}
Input:
  1) {test(part1(lines), 6816)}
  2) {test(part2(lines), 8163)}
"""
)
