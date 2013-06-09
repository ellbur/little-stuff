
object a {
	var x = 2
	
	override def x_=(_x: Int):Unit = {
		x = _x
		println("Set to " + x)
	}
}

a.x = 3

