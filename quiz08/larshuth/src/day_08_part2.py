import sys

d = {'L': 0, 'R': 1}

if __name__ == '__main__':
    inputs = dict()
    directions = ''

    for line in sys.stdin:
        try:
            line = line[:-1]
            line = line.replace(' ', '')

            node, ways = line.split('=')

            inputs[node] = ways[1:-1].split(',')

        except:
            if not line:
                if inputs == dict():
                    print(1)
                    continue
                else:
                    print(2)
                    break
            else:
                directions = list(line)

    print('finished input', inputs)

    directions = list(directions)
    print(directions)

    current_node = 'AAA'
    steps = 0
    while current_node != 'ZZZ':
        for direction in directions:
            current_node = inputs[current_node][d[direction]]
            steps += 1
            if current_node == 'ZZZ':
                break

    print(steps)
