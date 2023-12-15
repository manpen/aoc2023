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
    value = ['0' for _ in range(13)]
    hand = list(hand)
    hand.sort(key=assign_value_to_card, reverse=True)
    print(hand)

    if hand[0] == hand[1] == hand[2] == hand[3] == hand[4]:
        # Five of a kind
        print('5ok')
        value[0] = hex(assign_value_to_card(hand[0]))[2:]

    elif list(filter(lambda x: x == 4, [hand.count(card) for card in LIST_OF_CARDS])):
        # Four of a kind
        print('4ok')
        for card in LIST_OF_CARDS:
            if hand.count(card) == 4:
                value[1] = hex(assign_value_to_card(card))[2:]
                value[8] = hex(assign_value_to_card(''.join(list(filter(lambda x: x != card, hand)))[0]))[2:]
                break

    elif list(filter(lambda x: x == 3, [hand.count(card) for card in LIST_OF_CARDS])):
        if list(filter(lambda x: x == 2, [hand.count(card) for card in LIST_OF_CARDS])):
            # full house
            print('fh')
            for card in LIST_OF_CARDS:
                if hand.count(card) == 3:
                    value[2] = hex(assign_value_to_card(card))[2:]
                elif hand.count(card) == 2:
                    value[3] = hex(assign_value_to_card(card))[2:]
        else:
            # three of a kind
            print('3ok')
            for card in LIST_OF_CARDS:
                if hand.count(card) == 3:
                    value[4] = hex(assign_value_to_card(card))[2:]
                    rest_hand = sorted(list(filter(lambda x: x != card, hand)), key=assign_value_to_card, reverse=True)
                    value[8] = hex(assign_value_to_card(rest_hand[0]))[2:]
                    value[9] = hex(assign_value_to_card(rest_hand[1]))[2:]

    elif list(filter(lambda x: x == 2, [hand.count(card) for card in LIST_OF_CARDS])):
        if len(list(filter(lambda x: x == 2, [hand.count(card) for card in LIST_OF_CARDS]))) == 2:
            # two pairs
            print('2p')
            for card in LIST_OF_CARDS:
                if hand.count(card) == 2:
                    value[5] = hex(assign_value_to_card(card))[2:]
                    hand = list(filter(lambda c: c != card, list(hand)))
                    break
            for card in LIST_OF_CARDS:
                if hand.count(card) == 2:
                    value[6] = hex(assign_value_to_card(card))[2:]
                    break

        else:
            # one pair
            print('1p')
            for card in LIST_OF_CARDS:
                if hand.count(card) == 2:
                    value[7] = hex(assign_value_to_card(card))[2:]
                    rest_hand = sorted(list(filter(lambda x: x != card, hand)), key=assign_value_to_card, reverse=True)
                    value[8] = hex(assign_value_to_card(rest_hand[0]))[2:]
                    value[9] = hex(assign_value_to_card(rest_hand[1]))[2:]
                    value[10] = hex(assign_value_to_card(rest_hand[2]))[2:]
    else:
        # high card
        print('hc')
        for i in range(5):
            value[8 + i] = hex(assign_value_to_card(hand[i]))[2:]
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
