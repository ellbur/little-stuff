
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

tmp = binOp(ir, FMul, params$x, params$y)
tmp = binOp(ir, FAdd, tmp, params$z)
createReturn(ir, tmp)

verifyModule(mod)

val = run(foo, 4, 2, 3)

