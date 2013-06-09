
import up._
import HList._
import KList._
import ~>._

import scala.xml._

object Test {
    
    case class Field[+A](a: A)
    
    case class FieldList[HL <: HList](
            fields: KList[Field, HL],
            xml: NodeSeq
        )
    {
        def :&:[G](g: Field[G]) = this.copy(fields = KCons(g, fields))
        def :&:(x: NodeSeq) = this.copy(xml = x ++ xml)
    }
    val End = FieldList(KNil, Nil: NodeSeq)
    
    case class KInt[+T](i: Int)
    
    def main(args: Array[String]) {
        val parts = (
                <p/>
            :&: Field(2)
            :&: Field(3)
            :&: End
        )
            
        val ints = KInt(1) :^: KInt(2) :^: KNil
        
        println(parts)
        println(ints)
    }
}

