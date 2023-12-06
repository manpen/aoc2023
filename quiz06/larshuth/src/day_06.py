import sys
import re
from math import prod, sqrt, ceil

if __name__ == '__main__':
    lines = list()
    numbers_of_valid_ints = list()

    for line in sys.stdin:
        lines.append(line[:-1])
        if len(lines) == 2:
            break
    times, distances = lines
    _, times = times.split(':')
    _, distances = distances.split(':')
    times = times.split(' ')
    distances = distances.split(' ')

    times = list(filter(lambda a: a != '', times))
    distances = list(filter(lambda a: a != '', distances))

    times = list(map(int, times))
    distances = list(map(int, distances))

    print(times, distances)

    for t, d in zip(times, distances):
        mini = (t - sqrt(t**2 - 4*d)) / 2
        maxi = (t + sqrt(t**2 - 4*d)) / 2

        first_valid_int = int((mini // 1) + 1)
        last_valid_int = ceil(maxi) - 1

        numbers_of_valid_ints.append(maxi - mini + 1)

    print(prod(numbers_of_valid_ints))
