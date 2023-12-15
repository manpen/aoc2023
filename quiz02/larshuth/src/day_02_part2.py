import sys
import re

if __name__ == '__main__':
    total_sum = 0
    t = re.compile(' ')
    for line in sys.stdin:
        required_balls = {'red': 0, 'green': 0, 'blue': 0}
        line = line[:-1]
        try:
            pre, main = line.split(':')
        except:
            break
        sets = main.split(';')
        draws_per_round = [s.split(',') for s in sets]
        for round in draws_per_round:
            for draw in round:
                draw = draw[1:]
                print(draw, t.search(draw).start())
                print(draw[t.search(draw).start() + 1:])
                print(draw[:t.search(draw).start()])
                draw = draw.replace(',', '')
                required_balls[draw[t.search(draw).start() + 1:]] = max(
                    required_balls[draw[t.search(draw).start() + 1:]], int(draw[:t.search(draw).start()]))
        total_sum += required_balls['red'] * required_balls['blue'] * required_balls['green']
    print(total_sum)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
