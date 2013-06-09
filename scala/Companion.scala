
object A {
	class B {
	}
}
class A {
	val b = new A.B()
}

val a = new A()
println(a.b)

