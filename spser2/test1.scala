
object test1 {
//

// ---------------------------------------------------------------
// Products

trait HProject[P] {
    type A
    type B
    
    def aProj(p: P): A
    def bProj(p: P): B
}

implicit def pairProject[AA,BB] = new HProject[(AA,BB)] {
    type A = AA
    type B = BB
    
    def aProj(p: (A,B)) = p._1
    def bProj(p: (A,B)) = p._2
}

implicit def pairify[A](a: A) = new {
    def :+:[B](b: B) = (b, a)
}

// ---------------------------------------------------------------
// Case Products

// ---------------------------------------------------------------
// Show

trait Show[A] {
    def show(a: A): String
}
def show[A](a: A)(implicit show: Show[A]) = show.show(a)

implicit def showProject[P,AA,BB]
    (implicit proj: HProject[P]{type A=AA;type B=BB}, aShow: Show[AA], bShow: Show[BB]) = new Show[P]
{
    def show(p: P) = "%s :+: %s" format (
        aShow.show(proj.aProj(p)),
        bShow.show(proj.bProj(p))
    )
}

implicit def showUnit = new Show[Unit] {
    def show(u: Unit) = "()"
}

implicit def showInt = new Show[Int] {
    def show(i: Int) = i.toString
}

implicit def showString = new Show[String] {
    def show(s: String) = s
}

// ---------------------------------------------------------------
// Main

def main(args: Array[String]) {
    println { show(()) }
    println { show(1 :+: ()) }
    println { show(1 :+: "two" :+: ()) }
}

//
}

