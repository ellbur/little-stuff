
val fcp = (f: Int => Int) =>
    (n: Int) =>
        n match {
            case 0 => 1
            case _ => n * f(n-1)
        }

def fix1[A,B](f: (A => B) => (A => B)) = {
    def g(a: A): B = f(g _)(a)
    g _
}

val fact1 = fix1(fcp)
println(fact1(3))

def fix2[A,B](f: (A => B) => (A => B)) = {
    def g: A => B = f(g(_))
    g
}

val fact2 = fix2(fcp)
println(fact2(3))

def fix3[C](f: C => C): C = f(fix3(f))

try {
    val fact3 = fix3(fcp)
    println(fact3(3))
}
catch {
    case e: Any => println(e)
}

def fix4[A,B](f: (A=>B) => (A=>B)): A=>B =
    f(fix4(f)(_))

val fact4 = fix4(fcp)
println(fact4(3))

// def fix5[A,B](f: (A=>B) => (A=>B)): A=>B =
//    (a:A) => f(fix5(f)(a))

//val fact5 = fix5(fcp)
//println(fact5(3))
println("type error")

def fix6[A,B](f: (A=>B) => (A=>B)): A=>B =
    (a: A) => f(fix6(f))(a)

val fact6 = fix6(fcp)
println(fact6(3))

def fix7[A,B](f: (A=>B) => (A=>B)): A=>B =
    f(fix7(f))(_)

val fact7 = fix7(fcp)
println(fact7(3))

def fix8[A,B](f: (A=>B) => (A=>B)): A=>B =
    f((a: A) => fix8(f)(a))

val fact8 = fix8(fcp)
println(fact8(3))

