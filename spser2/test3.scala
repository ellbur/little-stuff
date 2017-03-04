
/*
object test3 {
//

// -----------------------------------------------------------
// Pair

trait Pair {
    type A
    type B
    
    def _1: A
    def _2: B
}

implicit def pairPair[PA,PB](p: (PA,PB)) = new Pair {
    type A = PA
    type B = PB
    
    def _1 = p._1
    def _2 = p._2
}

// -----------------------------------------------------------
// Show1

trait Show1 {
    def show1: String
}

implicit def show1Int(i: Int) = new Show1 {
    def show1 = i.toString
}

implicit def show1Pair[P,AA,BB](p: P)(implicit pair: P=>Pair{type A=AA;type B=BB},
    aShow: AA=>Show1, bShow: BB=>Show1) = new Show1
{
    def show1 = "(%s, %s)" format (p._1.show1, p._2.show1)
}

def main(args: Array[String]) {
    println { show1Pair(1,2).show1
    }
}

}
*/

