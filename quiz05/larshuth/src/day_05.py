import sys
import numpy as np
import math


def map_old_to_new(seeds, map_ranges):
    seed_pos = 0
    map_ranges_by_source_pos = 0
    displaced_before = 0

    old_seeds = np.array(sorted(seeds))
    new_seeds = list()
    map_ranges_by_source = sorted(map_ranges + [(math.inf, math.inf, 0)], key=lambda x: x[1])
    while len(new_seeds) != len(seeds):
        seed = old_seeds[seed_pos]
        if map_ranges_by_source[map_ranges_by_source_pos][1] <= seed < \
                map_ranges_by_source[map_ranges_by_source_pos][1] + \
                map_ranges_by_source[map_ranges_by_source_pos][2]:
            new_seeds.append(map_ranges_by_source[map_ranges_by_source_pos][0] + seed -
                             map_ranges_by_source[map_ranges_by_source_pos][1])
            seed_pos += 1
        elif seed > map_ranges_by_source[map_ranges_by_source_pos][1] + map_ranges_by_source[map_ranges_by_source_pos][2] - 1:
            map_ranges_by_source_pos += 1
        elif seed < map_ranges_by_source[map_ranges_by_source_pos][1]:
            displaced_before = sum([r if s < seed < d else 0 for d, s, r in map_ranges_by_source])
            new_seeds.append(seed - displaced_before)
            seed_pos += 1
        else:
            raise Exception('AAAAAAAAAAAHHHHHHHHHHHHHH')

    seeds = new_seeds
    return seeds


if __name__ == '__main__':
    current_map = -1
    map_ranges = list()
    m = dict()

    for line in sys.stdin:
        line = line[:-1]

        if line[:5] == 'seeds':
            _, main = line.split(':')
            seeds = main[1:].split(' ')
            seeds = list(map(int, seeds))
            seeds.sort()
            continue

        if line == '':
            if current_map != 6:
                continue
            else:
                seeds = map_old_to_new(seeds, map_ranges)
                break

        try:
            destination, source, range_len = line.split(' ')
            map_ranges.append((int(destination), int(source), int(range_len)))
        except:
            seeds = map_old_to_new(seeds, map_ranges)
            map_ranges = list()
            current_map += 1

    print(min(seeds))
