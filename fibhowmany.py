
def all_d(n):
    if n == 0:
        return [[]]
    else:
        before = all_d(n - 1)
        return [[x] + y for x in range(10) for y in before]

to_test = all_d(5)

def check_fib(nums):
    for a in range(10):
        for b in range(10):
            table = [0] * 10
            for i in nums:
                table[i] += 1
            
            def follow(a, b):
                if sum(table) == 0:
                    return True
                else:
                    if table[a] <= 0:
                        return False
                    else:
                        table[a] -= 1
                        return follow(b, (a+b) % 10)
            
            if follow(a, b):
                return True
    
    return False

total = 0
for i, s in zip(range(len(to_test)), to_test):
    if i % 100 == 0:
        print(i)
    if check_fib(s):
        total += 1
        
