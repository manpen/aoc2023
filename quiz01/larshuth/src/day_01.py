import sys
# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

# 655585-10fe490c


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    numbers = {str(i) for i in range(10)}
    total_sum = 0
    for line in sys.stdin:
        first = None
        last = None
        for c in line:
            if c in numbers:
                if first:
                    last = c
                else:
                    first = c
                    last = c
        if not first:
            break
        total_sum += (10 * int(first)) + int(last)
    print(total_sum)

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
