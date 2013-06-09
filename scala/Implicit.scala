
class A {
	//implicit def toInt() = 5
}
implicit def aToInt(a: A) = 5

val a = new A()
println(2 + a)

