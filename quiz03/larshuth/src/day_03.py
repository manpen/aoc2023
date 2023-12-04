import sys
import re
import numpy as np

line_length = 140

if __name__ == '__main__':
    numbers = {str(i) for i in range(10)}
    numbers_and_dot = numbers | {'.'}
    total_sum = 0
    line_count = 0
    previous = np.array(['.'] * line_length)
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
                    if (previous[check] not in numbers_and_dot) or (current[check] not in numbers_and_dot) or (
                            next[check] not in numbers_and_dot):
                        print(number, total_sum)
                        total_sum += int(number)
                        number = ''
                        break
                number = ''
            if pos == (line_length - 1) and number != '':
                for check in range(max(start_pos - 1, 0), pos + 1):
                    if (previous[check] not in numbers_and_dot) or (current[check] not in numbers_and_dot) or (
                            next[check] not in numbers_and_dot):
                        print(number, total_sum)
                        total_sum += int(number)
                        number = ''
                        break
                number = ''
        if line == '':
            break
    print(previous, current, next)
    print(total_sum)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
