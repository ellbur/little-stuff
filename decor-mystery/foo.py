
import time

class Timing(object):
    def __init__(self):
        pass

    def __call__(self, func):
        """Turn the object into a decorator"""
        def wrapper(*arg, **kwargs):
            return ()
        return wrapper

timings = Timing()
 
class A:
    
    @classmethod
    @timings
    def a(cls, x):
        print(x)

print A.a(2)

