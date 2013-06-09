
object a {
	private val xs = new Array[Int](2)
	
	def x(k: Int) = xs(k)
	def x_=(k: Int, x: Int) = xs(k) = x
}

println(a.x(0))
a.x(0) = 1

