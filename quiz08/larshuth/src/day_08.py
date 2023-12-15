import sys
import numpy as np

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
                    continue
                else:
                    break
            else:
                directions = list(line)

    print('finished input', inputs)

    directions = list(directions)
    print(directions)

    current_nodes = list(filter(lambda x: x[-1] == 'A', inputs))
    node_ends = list()

    for node in current_nodes:
        current_node = node
        seen = set()
        steps = 0
        z_pos = list()
        rep_steps = 0
        while current_node != 'ZZZ':
            for direction in directions:
                current_node = inputs[current_node][d[direction]]
                steps += 1
                if current_node[-1] == 'Z':
                    z_pos.append(steps)
                if current_node in seen:
                    rep_steps = steps
                    rep_node = current_node
                    break
                seen.add(current_node)
        current_nodes = node
        rep_pos = 0
        while current_node != rep_node:
            for direction in directions:
                current_node = inputs[current_node][d[direction]]
                rep_pos += 1
                if current_node == rep_node:
                    break
        node_ends.append((rep_steps - 1, rep_pos, z_pos))

    repeats = [rep_steps - rep_pos for rep_steps, rep_pos, _ in node_ends]
    all_nodes_path = [z_pos for _, _, z_pos in node_ends]
    least_z = [min(possible_zs) for possible_zs in all_nodes_path]
    while least_z.count(least_z[0]) < len(least_z):
        print(least_z)
        index_of_smallest_z_position = np.argmin(least_z)
        index_of_smallest_z_position_feasible_for_path = np.argmin(all_nodes_path[index_of_smallest_z_position])
        all_nodes_path[index_of_smallest_z_position][index_of_smallest_z_position_feasible_for_path] = \
        all_nodes_path[index_of_smallest_z_position][index_of_smallest_z_position_feasible_for_path] + repeats[
            index_of_smallest_z_position]
        least_z = [min(possible_zs) for possible_zs in all_nodes_path]

    # steps = 0
    # while list(filter(lambda x: x[-1] != 'Z', current_nodes)):
    #     for direction in directions:
    #         current_nodes = [inputs[node][d[direction]] for node in current_nodes]
    #         steps += 1
    #         print(steps, list(filter(lambda x: x[-1] != 'Z', current_nodes)))
    #         if not list(filter(lambda x: x[-1] != 'Z', current_nodes)):
    #             break

    print(least_z[0])
