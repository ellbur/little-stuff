
# http://www.omegahat.org/Rllvm/tut1.R

library(Rllvm)
InitializeNativeTarget() # Sounds fancy

mod = Module('Yo')

foo = Function('foo', DoubleType,
    c(
        x = DoubleType,
        y = DoubleType,
        z = DoubleType
    ),
    mod
)

params = getParameters(foo)
block = Block(foo)
ir = IRBuilder(block)

eval.env = (function() {
    
    `+` = function(a, b) binOp(ir, FAdd, a, b)
    `*` = function(a, b) binOp(ir, FMul, a, b)

    environment()
})()


createReturn(ir, with(eval.env,
    params$x * params$y + params$z
))

verifyModule(mod)

val = run(foo, 4, 2, 3)

t1 = function(n) for (i in 1L:n) run(foo, 4, 2, 3)
t2 = function() for (i in 1L:10000L) 4*2+3

