
/*
object test2 {
//

// ---------------------------------------------------------------
// Products

trait HProject {
    type A
    type B
    
    def _1: A
    def _2: B
}

implicit def pairProject[PA,PB] = { (p: (PA,PB)) =>
    new HProject {
        type A = PA
        type B = PB
        
        def _1 = p._1
        def _2 = p._2
    }
}

implicit def pairify[A](a: A) = new {
    def :+:[B](b: B) = (b, a)
}

// ---------------------------------------------------------------
// Show

trait Show {
    def show: String
}

implicit def showProject[P,AA,BB](p: P)
    (implicit proj: P=>HProject{type A=AA;type B=BB}, aShow: AA=>Show, bShow: BB=>Show) = new Show
{
    def show = "%s :+: %s" format (
        p._1.show,
        p._2.show
    )
}

implicit def showUnit(u: Unit) = new Show {
    def show = "()"
}

implicit def showInt(i: Int) = new Show {
    def show = i.toString
}

implicit def showString(s: String) = new Show {
    def show = s
}

// ---------------------------------------------------------------
// Main

def main(args: Array[String]) {
    println { ().show }
    println { (1 :+: ()).show }
}

//
}
*/

