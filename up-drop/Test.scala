
import up._
import HList._
import KList._
import ~>._

import scala.xml._

object Test {
    
    sealed abstract class Part[+A]
    case class Blank() extends Part[Nothing]
    case class Field[+A](a: A) extends Part[A]
    
    case class PartList[HL <: HList](pl: KList[Part, HL]) {
        def :&:[G](g: Part[G]) = KCons(g, pl)
    }
    implicit def toPartList[HL <: HList](pl: KList[Part, HL]) = PartList(pl)
    
    def main(args: Array[String]) {
        
        val parts = Blank() :&: Field(2) :&: Field(3) :&: KNil
        println(parts)
            
    }
}

