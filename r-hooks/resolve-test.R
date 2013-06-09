
source('hooks-3.R')

aoeu = function(x) UseMethod('aoeu')
aoeu.default = function(x) print(2)

with(r, aoeu(2))

