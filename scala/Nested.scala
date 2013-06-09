
class A {
	def foo(x: Int) = x + 1
	
	class B {
		def foo(x: Int) = 
			A.this.foo(x) + 1
	}
}

val a = new A()
val b = new a.B()

println(a.foo(0))
println(b.foo(0))

