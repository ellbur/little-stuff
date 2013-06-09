
package uptest

import up._
import HList._
import KList._
import ~>._

case class Produce[+T](p: Int => T) {
    def extract(n: Int): T = p(n)
}

object Test {
    
    def main(args: Array[String]) {
        
        val s = 1 :: "yo" :: HNil
        
        s match {
            case a :: b :: HNil =>
                println(a)
                println(b)
        }
        
        val l = Produce(x => x + 1) :^: Produce(x => "this: %d" format x) :^: KNil
        def extract(n: Int)
            = new (Produce ~> Id) {
                def apply[T](p: Produce[T]): T = p.extract(n)
            }
        
        val m = l down extract(4)
        
        println(l)
        println(m)
    }
}

