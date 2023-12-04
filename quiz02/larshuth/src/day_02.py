import sys
import re

if __name__ == '__main__':
    total_sum = 0
    t = re.compile(' ')
    for line in sys.stdin:
        going = True
        try:
            pre, main = line.split(':')
        except:
            break
        sets = main.split(';')
        draws_per_round = [s.split(',') for s in sets]
        for round in draws_per_round:
            for draw in round:
                if not going:
                    continue
                draw = draw[1:]
                draw = draw.replace(',', '')
                if ('red' in draw and int(draw[:t.search(draw).start()]) > 12) or (
                        'green' in draw and int(draw[:t.search(draw).start()]) > 13) or (
                        'blue' in draw and int(draw[:t.search(draw).start()]) > 14):
                    going = False
        if going:
            game_id = int(pre[t.search(pre).start() + 1:])
            total_sum += game_id
    print(total_sum)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
