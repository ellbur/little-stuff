
from macropy.macros.adt import macros, case

@case
class Yo(x): pass

print(Yo(2))

