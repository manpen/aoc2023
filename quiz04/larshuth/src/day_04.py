import sys
import re

if __name__ == '__main__':
    total_sum = 0
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

        print(winning, gotten)
        for w in winning:
            if w in gotten:
                points_for_card += 1
        if points_for_card >= 0:
            total_sum += 2 ** points_for_card
    print(total_sum)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
