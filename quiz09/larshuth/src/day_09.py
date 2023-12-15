import sys
import numpy as np

if __name__ == '__main__':
    sequence = list()
    total_sum = 0

    for line in sys.stdin:
        line = line[:-1]
        if not line:
            break
        sequence = list(map(int, line.split(' ')))
        sequences = [sequence]
        while sequences[-1].count(sequences[-1][0]) != len(sequences[-1]):
            s = list()
            previous = sequences[-1][0]
            for i in sequences[-1][1:]:
                s.append(i - previous)
                previous = i
            sequences.append(s)
        rek1 = lambda x, l: rek1(l[-1][-1] + x, l[:-1]) if len(l) != 1 else l[-1][-1] + x
        print(sequences, rek1(0, sequences))
        total_sum += rek1(0, sequences)

    print(total_sum)
