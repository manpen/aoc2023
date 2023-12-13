import sys
import numpy as np

if __name__ == '__main__':
    overhead = 300
    cards = 213

    total_sum = 0
    line_number = 0
    number_of_cards = np.array([1] * overhead)

    for line in sys.stdin:
        points_for_card = -1
        try:
            _, main = line.split(':')
        except:
            break
        winning, gotten = main.split('|')
        winning = set(winning.split(' ')) - {'', ' '}
        winning = set(int(w) for w in winning)

        gotten = set(gotten.split(' ')) - {'', ' '}
        gotten = set(int(g) for g in gotten)

        for w in winning:
            if w in gotten:
                points_for_card += 1
        if points_for_card >= 0:
            for i in range(1, points_for_card + 2):
                number_of_cards[line_number + i] += number_of_cards[line_number]
        line_number += 1

    print(sum(number_of_cards[:cards]))

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
