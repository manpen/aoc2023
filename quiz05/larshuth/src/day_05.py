import sys
import re

if __name__ == '__main__':
    # seed_to_soil = dict()
    # soil_to_fertilizer = dict()
    # fertilizer_to_water = dict()
    # water_to_light = dict()
    # light_to_temperature = dict()
    # temperature_to_humidity = dict()
    # humidity_to_location = dict()

    # list_of_maps = [seed_to_soil, soil_to_fertilizer, fertilizer_to_water, water_to_light, light_to_temperature,
    #                 temperature_to_humidity, humidity_to_location]

    current_map = -1
    map_ranges = list()
    m = dict()

    for line in sys.stdin:
        line = line[:-1]

        if line[:5] == 'seeds':
            _, main = line.split(':')
            seeds = main[1:].split(' ')
            seeds = list(map(int, seeds))
            continue

        if line == '':
            if current_map != 6:
                continue
            else:
                max_of_map = max(seeds)
                used = set()
                for destination, source, range_len in map_ranges:
                    for i in range(range_len):
                        m[source + i] = destination + i
                        used.add(destination + i)

                open = set(range(max_of_map + 1)) - used

                for i in range(max_of_map + 1):
                    try:
                        m[i]
                    except:
                        m[i] = min(open)
                        open.remove(min(open))

                seeds = [m[s] for s in seeds]
                break

        try:
            destination, source, range_len = line.split(' ')
            map_ranges.append((int(destination), int(source), int(range_len)))
        except:
            # a new map begins
            # first finish previous map
            max_of_map = max(seeds)
            used = set()
            for destination, source, range_len in map_ranges:
                for i in range(range_len):
                    m[source + i] = destination + i
                    used.add(destination + i)

            open = set(range(max_of_map + 1)) - used

            for i in range(max_of_map + 1):
                try:
                    m[i]
                except:
                    m[i] = min(open)
                    open.remove(min(open))

            seeds = [m[s] for s in seeds]

            current_map += 1
            map_ranges = list()
            m = dict()

    print(min(seeds))
