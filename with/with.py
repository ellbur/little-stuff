
class A:
    
    def __enter__(self):
        print 'Enter A'
    
    def __exit__(self, *stuff):
        print 'Exit A'
        
class B:
    
    def __enter__(self):
        print 'Enter B'
    
    def __exit__(self, *stuff):
        print 'Exit B'

def foo(a):
    with B() as b:
        print 'Inside'

def bar():
    with A() as a:
        foo(a)

bar()

