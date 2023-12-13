import sys
import re
import numpy as np
from itertools import product

line_length = 140

if __name__ == '__main__':
    numbers_by_gear = {i: list() for i in product(range(line_length + 2), range(line_length + 2))}
    numbers = {str(i) for i in range(10)}
    total_sum = 0
    line_count = 0
    current = np.array(['.'] * line_length)
    next = np.array(['.'] * line_length)
    for line in sys.stdin:
        line = line.replace('\n', '')
        if line == '':
            previous = current
            current = next
            next = np.array(['.'] * line_length)
        else:
            previous = current
            current = next
            next = np.array(list(line))

        number = ''
        for pos in range(line_length):
            symbol = current[pos]
            if symbol in numbers:
                if number == '':
                    start_pos = pos
                number += symbol
            elif number != '':
                for check in range(max(start_pos - 1, 0), pos + 1):
                    if previous[check] == '*':
                        numbers_by_gear[(line_count - 1, check)].append(int(number))
                        number = ''
                        break
                    elif current[check] == '*':
                        numbers_by_gear[(line_count, check)].append(int(number))
                        number = ''
                        break
                    elif next[check] == '*':
                        numbers_by_gear[(line_count + 1, check)].append(int(number))
                        number = ''
                        break
                number = ''
            if pos == (line_length - 1) and number != '':
                for check in range(max(start_pos - 1, 0), pos + 1):
                    if previous[check] == '*':
                        numbers_by_gear[(line_count - 1, check)].append(int(number))
                        number = ''
                    elif current[check] == '*':
                        numbers_by_gear[(line_count, check)].append(int(number))
                        number = ''
                    elif next[check] == '*':
                        numbers_by_gear[(line_count + 1, check)].append(int(number))
                        number = ''
                number = ''
        if line == '':
            break
        line_count += 1

    for _, gear_parts in numbers_by_gear.items():
        if len(gear_parts) == 2:
            total_sum += gear_parts[0] * gear_parts[1]

    print(total_sum)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
