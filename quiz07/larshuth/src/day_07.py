import sys
import re
from math import prod, sqrt, ceil

LIST_OF_CARDS = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
INPUT_LENGTH = 1000


def assign_value_to_card(card):
    try:
        return int(card)
    except ValueError:
        val = {'A': 14, 'K': 13, 'Q': 12, 'J': 11, 'T': 10}
        return val[card]


def assign_value_to_hand(hand):
    value = ['0' for _ in range(6)] + [hex(assign_value_to_card(card))[2:] for card in hand]

    if hand[0] == hand[1] == hand[2] == hand[3] == hand[4]:
        # Five of a kind
        value[0] = '1'

    elif list(filter(lambda x: x == 4, [hand.count(card) for card in LIST_OF_CARDS])):
        # Four of a kind
        value[1] = '1'

    elif list(filter(lambda x: x == 3, [hand.count(card) for card in LIST_OF_CARDS])):
        if list(filter(lambda x: x == 2, [hand.count(card) for card in LIST_OF_CARDS])):
            # full house
            value[2] = '1'
        else:
            # three of a kind
            value[3] = '1'

    elif list(filter(lambda x: x == 2, [hand.count(card) for card in LIST_OF_CARDS])):
        if len(list(filter(lambda x: x == 2, [hand.count(card) for card in LIST_OF_CARDS]))) == 2:
            # two pairs
            value[4] = '1'

        else:
            # one pair
            value[5] = '1'
    else:
        # high card
        pass
    return value


if __name__ == '__main__':
    inputs = list()

    for line in sys.stdin:
        line = line[:-1]
        hand, bid = line.split(' ')
        bid = int(bid)
        inputs.append((assign_value_to_hand(hand), hand, bid))

        if len(inputs) == INPUT_LENGTH:
            break

    inputs.sort(key=lambda x: int(''.join(x[0]), base=16), reverse=False)
    print([(''.join(a), b, c) for a, b, c in inputs])
    total = sum([bid * (rank + 1) for rank, (_, _, bid) in enumerate(inputs)])
    print(total)
