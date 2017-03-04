
/*
object DynamicStructure3 extends scala.App {

  trait Node[+B]

  case class App[+B](car: B, cdr: B) extends Node[B]
  object AppYo {
    def unapply(b: Bubble): Option[(b.B, b.B)] = b.toNode match {
      case App(car, cdr) => Some((car, cdr))
      case _ => None
    }
  }

  case class IntLiteral(n: Int) extends Node[Nothing]
  object IntLiteralYo {
    def unapply(b: Bubble): Option[Int] = b.toNode match {
      case IntLiteral(n) => Some(n)
      case _ => None
    }
  }

  object Magic23 {
    def unapply(b: Bubble): Boolean = b match {
      case AppYo(IntLiteralYo(2), IntLiteralYo(3)) => true
      case _ => false
    }
  }

  trait Bubble {
    type B <: Bubble
    def toNode: Node[B]
  }

  trait BasicBubble extends Bubble {
    type B = BasicBubble
  }

  case class BasicApp(car: BasicBubble, cdr: BasicBubble) extends BasicBubble {
    def toNode = App(car, cdr)
  }

  case class BasicIntLiteral(n: Int) extends BasicBubble {
    def toNode = IntLiteral(n)
  }

  val f1 = BasicApp(BasicIntLiteral(2), BasicIntLiteral(3))
  val f2 = BasicApp(BasicIntLiteral(2), BasicIntLiteral(4))

  println(Magic23.unapply(f1))
  println(Magic23.unapply(f2))
}
*/

