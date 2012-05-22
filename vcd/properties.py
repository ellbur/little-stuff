
import vcd

def asserted_times(sig):
    count = 0
    was_zero = True
    for change in sig.changes():
        _, v = change
        if was_zero and v == '1':
            count += 1
            was_zero = False
        elif v == '0':
            was_zero = True
    return count

