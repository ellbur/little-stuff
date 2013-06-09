
import scala.util.continuations._

object Test {
    
    def each[A,B](s: Seq[A]) = shift { (c: A=>B) =>
        s map c
    }
    
    def main(args: Array[String]) {
        val b = reset {
            each[Int,Seq[Int]](Seq(1, 2, 3)) + each[Int,Int](Seq(1, 2, 3))
        }
        
        println(b)
    }
}

